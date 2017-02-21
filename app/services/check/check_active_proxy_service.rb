class Check::CheckActiveProxyService
  attr_reader :args

  def initialize args
    @ip = args[:ip]
    @port = args[:port]
  end

  def perform?
    res = HTTP.via(@ip, @port).get "http://whatismyipaddress.com"
    page = Nokogiri::HTML res.body.to_s
    if page.css("div#main_content @href")[0].nil?
      false
    else
      str = page.css("div#main_content @href")[0].value
      true if str[27..str.length] == @ip
    end
  end
end
