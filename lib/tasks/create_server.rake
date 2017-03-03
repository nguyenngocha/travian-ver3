namespace :db do
  desc "Import server"
  task create_server: [:environment] do
    Domain.each do |d|
      d.servers.destroy_all
      d.destroy
    end

    domain = Domain.create name: "travian.com.vn"
    domain.servers.create! name: "ts1.travian.com.vn"
    domain.servers.create! name: "ts19.travian.com.vn"
    domain.servers.create! name: "ts20.travian.com.vn"
    User.create email: "admin@gmail.com", password: "123456", is_admin: true
  end
end
