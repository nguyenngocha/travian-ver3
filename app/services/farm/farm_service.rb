class Farm::FarmService
  attr_reader :args

  def initialize args
    @user = args[:user]
    @account = args[:account]
    @farm_list = args[:farm_list]
  end

  def perform
    Time.zone = "Hanoi"
    puts "#{@account.username}-#{@farm_list.name}"
    if get_troop()
      puts "#{Time.zone.now}: get troop true"
      send_request1()
      if @respond_params.any?
        send_request2()
      end
    else
      puts "Get troop false"
    end
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

  def check_current_troop farm
    army1 = farm.army1.nil? ? 0 : farm.army1
    army2 = farm.army2.nil? ? 0 : farm.army2
    army3 = farm.army3.nil? ? 0 : farm.army3
    army4 = farm.army4.nil? ? 0 : farm.army4
    army5 = farm.army5.nil? ? 0 : farm.army5
    army6 = farm.army6.nil? ? 0 : farm.army6
    army7 = farm.army7.nil? ? 0 : farm.army7
    army8 = farm.army8.nil? ? 0 : farm.army8
    army9 = farm.army9.nil? ? 0 : farm.army9
    army10 = farm.army10.nil? ? 0 : farm.army10
    army11 = farm.army11.nil? ? 0 : farm.army11

    if @troop_info[:army1] >= army1 && @troop_info[:army2] >= army2 &&
      @troop_info[:army3] >= army3 && @troop_info[:army4] >= army4 &&
      @troop_info[:army5] >= army5 && @troop_info[:army6] >= army6 &&
      @troop_info[:army7] >= army7 && @troop_info[:army8] >= army8 &&
      @troop_info[:army9] >= army9 && @troop_info[:army10] >= army10 &&
      @troop_info[:army11] >= army11

      @troop_info[:army1] -= army1
      @troop_info[:army2] -= army2
      @troop_info[:army3] -= army3
      @troop_info[:army4] -= army4
      @troop_info[:army5] -= army5
      @troop_info[:army6] -= army6
      @troop_info[:army7] -= army7
      @troop_info[:army8] -= army8
      @troop_info[:army9] -= army9
      @troop_info[:army10] -= army10
      @troop_info[:army11] -= army11
      true
    else
      false
    end
  end

  def get_troop
    url = "http://#{@account.server_id}/build.php?newdid=#{@farm_list.village_id}&id=39&gid=16&tt=2"
    @cookies = Hash.new
    @cookies[:T3E] = @account.t3e
    @cookies[:lowRes] = 0
    @cookies[:sess_id] = @account.sess_id
    @troop_info = Hash.new
    if @user.is_admin?
      res = HTTP.cookies(@cookies).get url
    else
      res = HTTP.via(@user.ip, @user.port).cookies(@cookies).get url
    end
    @page = Nokogiri::HTML res.body.to_s
    if @page.css("div#header ul#navigation").empty?
      return false unless login()
    end
    current_armies = @page.css("table#troops td")
    if current_armies.blank?
      return false
    else
      @troop_info[:army1] = current_armies[0].css("a[href= '#']").text.to_i
      @troop_info[:army2] = current_armies[4].css("a[href= '#']").text.to_i
      @troop_info[:army3] = current_armies[8].css("a[href= '#']").text.to_i
      @troop_info[:army4] = current_armies[1].css("a[href= '#']").text.to_i
      @troop_info[:army5] = current_armies[5].css("a[href= '#']").text.to_i
      @troop_info[:army6] = current_armies[9].css("a[href= '#']").text.to_i
      @troop_info[:army7] = current_armies[2].css("a[href= '#']").text.to_i
      @troop_info[:army8] = current_armies[6].css("a[href= '#']").text.to_i
      @troop_info[:army9] = current_armies[3].css("a[href= '#']").text.to_i
      @troop_info[:army10] = current_armies[7].css("a[href= '#']").text.to_i
      @troop_info[:army11] = current_armies[11].css("a[href= '#']").text.to_i
      @troop_info[:timestamp] = @page.css("input[name='timestamp'] @value").text
      @troop_info[:timestamp_checksum] = @page.css("input[name='timestamp_checksum'] @value").text
      return true
    end
  end

  def send_request1
    url = "http://#{@account.server_id}/build.php?id=39&gid=16&tt=2"
    @respond_params = Array.new
    @farm_list.farms.shuffle.each do |farm|
      form = Hash.new
      param = Hash.new
      if farm.status && check_current_troop(farm)

        form[:timestamp] = @troop_info[:timestamp]
        form[:timestamp_checksum] = @troop_info[:timestamp_checksum]
        form[:b] = 1
        form[:currentDid] = @farm_list.village_id
        form[:x] = farm.x
        form[:y] = farm.y
        form[:c] = 4
        form[:t1] = farm.army1
        form[:t2] = farm.army2
        form[:t3] = farm.army3
        form[:t4] = farm.army4
        form[:t5] = farm.army5
        form[:t6] = farm.army6
        form[:t7] = farm.army7
        form[:t8] = farm.army8
        form[:t9] = farm.army9
        form[:t10] = farm.army10
        form[:t11] = farm.army11

        if @user.is_admin?
          res = HTTP.cookies(@cookies).post url, form: form
        else
          res = HTTP.via(@user.ip, @user.port).cookies(@cookies).post url, form: form
        end
        page = Nokogiri::HTML res.body.to_s
        unless page.css("input[name='a'] @value").text.blank?

          param[:timestamp] = page.css("input[name='timestamp'] @value").text
          param[:timestamp_checksum] = page.css("input[name='timestamp_checksum'] @value").text
          param[:a] = page.css("input[name='a'] @value").text
          param[:id] = 39
          param[:c] = 4
          param[:kid] = page.css("input[name='kid'] @value").text
          param[:b] = 2
          param[:x] = page.css("input[name='x'] @value").text
          param[:y] = page.css("input[name='y'] @value").text
          param[:currentDid] = page.css("input[name='currentDid'] @value").text
          param[:t1] = page.css("input[name='t1'] @value").text
          param[:t2] = page.css("input[name='t2'] @value").text
          param[:t3] = page.css("input[name='t3'] @value").text
          param[:t4] = page.css("input[name='t4'] @value").text
          param[:t5] = page.css("input[name='t5'] @value").text
          param[:t6] = page.css("input[name='t6'] @value").text
          param[:t7] = page.css("input[name='t7'] @value").text
          param[:t8] = page.css("input[name='t8'] @value").text
          param[:t9] = page.css("input[name='t9'] @value").text
          param[:t10] = page.css("input[name='t10'] @value").text
          param[:t11] = page.css("input[name='t11'] @value").text
          puts "(#{param[:x]}|#{param[:y]})"
          @respond_params << param
        end
      end
    end
  end

  def send_request2
    url = "http://#{@account.server_id}/build.php?id=39&gid=16&tt=2"
    @respond_params.each do |param|
      if @user.is_admin?
        HTTP.cookies(@cookies).post url, form: param
      else
        HTTP.via(@user.ip, @user.port).cookies(@cookies).post url, form: param
      end
    end
    Time.zone = "Hanoi"
    puts "#{Time.zone.now}: Gui #{@respond_params.size} dot"
  end
end
