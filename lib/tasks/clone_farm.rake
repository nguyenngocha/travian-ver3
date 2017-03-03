namespace :job do
  desc "TODO"
  task clone_farms: :environment do
    user = User.first
    account = user.accounts.first

    farm_file = File.open("db/seeds.rb", "w")
    dotham_file = File.open("db/dotham.txt", "w")

    string = "puts 'clear farms'\n\n"
    # string += "User.first.accounts.first.farm_lists.each do |farm_list|\n"
    # string += "  farm_list.farms.destroy_all\n"
    # string += "end\n\n"
    string += "User.first.accounts.first.farm_lists.second.farms.destroy_all\n\n"
    string += "puts 'remake farms ...'\n\n"

    farm_file.puts string
    farm_file.puts "#list cap-farm"

    x = 64
    y = 17
    distance = 150

    a = distance / 17
    b = 2 * a
    x0 = x - 17*a
    y0 = y - 17*a
    array = Array.new

    (0..b).each do |m|
      (0..b).each do |n|
        array << [x0 + 17 * m, y0 + 17 *n]
      end
    end

    puts "clone farms for village: (#{x}|#{y})"
    Time.zone = "Hanoi"
    puts "start: #{Time.zone.now}"

    array.each do |a|
      Clone::CloneFarmService.new(server: "ts20.travian.com.vn",
        user: user, account: account, farm_file: farm_file, dotham_file: dotham_file,
        group_name: "second", x: a[0], y: a[1], village: account.villages.fourth).perform
    end

    puts "finish: #{Time.zone.now}\n"
  end
end
