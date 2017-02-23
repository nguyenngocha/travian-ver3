class Upgrate::UpgrateService
  attr_reader :args

  def initialize args
    @user = args[:user]
    @account = args[:account]
    @village = args[:village]
  end

  def perform
    upgrate @village
  end

  private
  def login
    current_time = Time.now.to_i
    url = "http://#{@account.server_id}/dorf1.php"
    if @user.is_admin?
      res = HTTP.post url, form: {name: @account.username,
        password: @account.password, login: current_time}
    else
      res = HTTP.via(@user.ip, @user.port).post url, form: {name: @account.username,
        password: @account.password, login: current_time}
    end
    @page = Nokogiri::HTML res.body.to_s
    if @page.css("div#header ul#navigation").empty?
      puts "Dang nhap lai va loi"
      false
    else
      parse_cookies res.cookies.cookies, @page
      @account.update_attributes t3e: @cookies["T3E"],
        sess_id: @cookies["sess_id"], ajax_token: @ajax_token, player_uuid: @player_uuid
      puts "Dang nhap lai va thanh cong"
      true
    end
  end

  def parse_cookies cookies, page
    @cookies = Hash.new
    cookies.each do |cookie|
      @cookies[cookie.name] = cookie.value
    end
    array = page.css("script").first.child.text.gsub(/\n\t/, '').
      gsub(/ = '/, ',').gsub(/'\;/, ',').gsub(/,\n/, '').split(',')
    hash = Hash[*array]
    @ajax_token = hash["window.ajaxToken"]
    @player_uuid = hash["window._player_uuid"]
  end

  def upgrate village
    Time.zone = "Hanoi"
    upgrate_id = village.upgrate_schedules.first.upgrate_id
    url = "http://#{@account.server_id}/build.php?newdid=#{village.id}&id=#{upgrate_id}"

    @cookies = Hash.new
    @cookies[:T3E] = @account.t3e
    @cookies[:lowRes] = 0
    @cookies[:sess_id] = @account.sess_id
    @troop_info = Hash.new
    if @user.is_admin?
      response = HTTP.cookies(@cookies).get url
    else
      response = HTTP.via(@user.ip, @user.port).cookies(@cookies).get url
    end
    @page = Nokogiri::HTML response.body.to_s
    if @page.css("div#header ul#navigation").empty?
      return false unless login()
      response = HTTP.cookies(@cookies).get url
    end

    response = Nokogiri::HTML response.body.to_s
    upgrate_button = response.css("#content #build button").first

    if upgrate_button.attr("class").include? "green"
      link = upgrate_button.attr("onclick").match(/'([^']+)'/)[1]
      link = "http://#{@account.server_id}/" + link
      response = HTTP.cookies(@cookies).get link
      village.upgrate_schedules.first.destroy
      puts "success"
      return true
    elsif upgrate_button.attr("class").include? "gold"
      puts "hết tài nguyên hoặc quá giới hạn công trình đang xây"
      return false
    else
      puts "éo có lỗi gì đâu, có vào cho đủ case thôi"
      return false
    end
  end
end
