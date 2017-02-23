class Check::GetActiveProxyService
  attr_reader :args

  def initialize args
    @current_user = args[:current_user]
  end

  def perform?
    return true if @current_user.is_admin?
    if @current_user.ip.present?
      if check_proxy? @current_user.ip, @current_user.port
        return true
      else
        proxy = Proxy.find_by(id: @current_user.ip)
        proxy.update_attributes status: false, used: false if proxy
      end
    end
    proxy = Proxy.first_element
    if proxy.nil?
      return false
    else
      if check_proxy? proxy.ip, proxy.port
        @current_user.update_attributes ip: proxy.ip, port: proxy.port
        proxy.update_attributes used: true
        true
      else
        proxy.update_attributes status: false
        Check::GetActiveProxyService.new(current_user: @current_user).perform?
      end
    end
  end

  private
  def check_proxy? ip, port
    res = HTTP.via(ip, port).get "http://whatismyipaddress.com"
    page = Nokogiri::HTML res.body.to_s
    if page.css("div#main_content @href")[0].nil?
      false
    else
      str = page.css("div#main_content @href")[0].value
      true if str[27..str.length] == ip
    end
  end
end
