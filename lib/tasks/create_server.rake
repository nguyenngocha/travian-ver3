namespace :db do
  desc "Import server"
  task create_server: [:environment] do
    domain = Domain.create name: "travian.com.vn"
    domain.servers.create! name: "ts1.travian.com.vn"
    domain.servers.create! name: "ts19.travian.com.vn"
  end
end
