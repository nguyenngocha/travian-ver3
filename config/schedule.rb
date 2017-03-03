set :output, "/home/ngocha/log.log"

every 10.minutes do
  rake "job:farm"
end

# every 1.hours do
#   rake "job:farm_oasis"
# end

every "4,9,14,19,24,29,34,39,44,49,54,59 * * * *" do
  rake "job:upgrate"
end

# every 7.minutes do
#   rake "job:upgrate"
# end

# every "0 0 * * *" do
#   rake "job:clone_farms"
#   rake "db:seed"
# end

# whenever --update-crontab --set environment=development	
# crontab -l
# crontab -r

