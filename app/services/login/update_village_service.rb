class Login::UpdateVillageService
  attr_reader :args

  def initialize args
    @current_account = args[:current_account]
    @page = args[:page]
  end

  def perform?
    if parse_data()
      @arr_newdid.each_index do |n|
        village = @current_account.villages.find @arr_newdid[n]
        if village
          village.update_attributes name: @arr_name[n]
        else
          @current_account.villages.create id: @arr_newdid[n], name: @arr_name[n],
            x: @arr_latlong[n][0], y: @arr_latlong[n][1]
        end
      end
      true
    else
      false
    end
  end

  private
  def parse_data
    @ha = Hash.new
    @arr_latlong = Array.new
    @arr_name = Array.new
    @arr_newdid = Array.new
    newdids = @page.css("div.innerBox.content ul li a @href")
    newdids.each do |newdid|
      if newdid.value.starts_with? "?newdid"
        @arr_newdid << newdid.value[8..newdid.value.length-2].to_i
      end
    end
    names = @page.css("div.innerBox.content ul li a div[class='name']")
    names.each do |name|
      @arr_name << name.text
    end
    latlongs = @page.css("div.innerBox.content ul li a span.coordinates").text.split(')')
    latlongs.each do |latlong|
      @arr_latlong << latlong.split(/[^\d, \|, -]/).join.split('|').map!(&:to_i)
    end
    if ((@arr_latlong.length == @arr_name.length) && (@arr_name.length == @arr_newdid.length))
      true
    else
      false
    end
  end
end
