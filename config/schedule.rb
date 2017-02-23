set :output, "/home/hatd/log.log"

every 10.minutes do
  rake "job:farm"
end

# every 1.hours do
#   rake "job:farm_oasis"
# end

every 13.minutes do
  rake "rake job:upgrate"
end

# whenever --update-crontab --set environment=development
# crontab -l
# crontab -r

