class Clone::CloneFarmService
  attr_reader :args

  def initialize args
    @server = args[:server]
    @user = args[:user]
    @account = args[:account]
    @farm_file = args[:farm_file]
    @dotham_file = args[:dotham_file]
    @group_name = args[:group_name]
    @x = args[:x]
    @y = args[:y]
    @village = args[:village]
  end

  def perform
    @cookies = Hash.new
    @cookies[:T3E] = @account.t3e
    @cookies[:sess_id] = @account.sess_id
    @cookies[:lowRes] = 0

    url = "http://ts20.travian.com.vn/dorf1.php"
    respond = HTTP.cookies(@cookies).get url
    sleep 1

    @page = Nokogiri::HTML respond.body.to_s
    if @page.css("div#header ul#navigation").empty?
      return false unless login()
    end

    url = create_url @account.server_id, @x, @y, @account.ajax_token
    respond = HTTP.cookies(@cookies).get url
    sleep 1

    data = respond.parse["response"]["data"]["tiles"]
    puts "clone for (#{@x}, #{@y})"

    parse_data data
  end

  private
  def create_url server, x, y, ajax_token
    "http://" + server + "/ajax.php?cmd=mapPositionData&data[x]=" + x.to_s +
      "&data[y]=" + y.to_s + "&data[zoomLevel]=2&ajaxToken=" + ajax_token
  end

  def parse_data datas
    datas.each do |data|

      x = data["x"].to_i
      y = data["y"].to_i

      if data["c"].present?
        text = (Nokogiri::HTML data["t"]).text.gsub(/\ \{/, '{').gsub(/\{/, ' {').split
        c = data["c"].split

        if c[0] == "{k.dt}"
          url = "http://#{@account.server_id}/position_details.php?x=#{x}&y=#{y}"
          responses = HTTP.cookies(@cookies).get url
          responses = Nokogiri::HTML responses.to_s
          sleep 0.5 + rand*0.5

          check_login = responses.css(".innerLoginBox")
          if check_login.present?
            return false unless login()
          end

          #bi admin ban thi k add farm
          disable = responses.css(".detailImage .option")[1]
          disable = disable.css("span") if disable
          next if disable.present?
          #trung lien minh thi k add do tham
          lm = responses.css("#village_info tr")[1]
          lm = lm.css("td").text if lm

          if lm
            next if lm.downcase.include? "tg"
            next if lm.downcase.include? "qg"
          end

          if responses.css(".instantTabs td img").present?
            # chi add farm neu report toan la tan cong thang loi va k die linh
            imgs = responses.css(".instantTabs td img").select {|img| img["class"].split[0] == "iReport"}
            ds = responses.css("#village_info tr")[3].css("td").text.to_i
            if ds > 150
              @farm_file.puts "User.first.accounts.first.farm_lists.#{@group_name}.farms.create! x: #{x}, y: #{y}, army4: 25" if is_farm? imgs
              puts "farm #{url} - #{distance x,y} > 150 pop - LM: #{lm}" if is_farm? imgs
            # else
              # @farm_file.puts "User.first.accounts.first.farm_lists.#{@group_name}.farms.create! x: #{x}, y: #{y}, army4: 3" if is_farm? imgs
              # puts "farm #{url} - #{distance x,y} < 150 pop" if is_farm? imgs
            end
          else

            # # neu dan so > 150 thi k add
            # ds = responses.css("#village_info tr")[3].css("td").text.to_i
            # next if ds > 150

            @dotham_file.puts "#{url}|#{distance x,y}"
            puts "do tham #{url} - distance: #{distance x,y}"
          end
        end
      end
    end
  end

  def is_farm? imgs
    imgs.each do |img|
      irp = img.attr("class").split.second
      return false if irp != "iReport1" && irp != "iReport15" && irp != "iReport2"
    end
    return true
  end

  def distance x,y
    return Math.sqrt((@village.x - x)**2 + (@village.y - y)**2)
  end

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
end
