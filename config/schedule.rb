set :output, "/home/hatd/log.log"

every 10.minutes do
  rake "job:farm"
end

# every 1.hours do
#   rake "job:farm_oasis"
# end

# every 10.minutes do
#   rake "job:auto_upgrate_random_dorf1"
# end

# whenever --update-crontab --set environment=development
# crontab -l
# crontab -r

