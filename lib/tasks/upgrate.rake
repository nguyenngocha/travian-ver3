namespace :job do
  desc "Farm"
  task upgrate: [:environment] do
    # @users = User.all
    User.all.each do |user|
      # accounts = user.accounts
      user.accounts.each do |account|
        account.villages.each do |village|
          if village.upgrate_schedules.present?
            Upgrate::UpgrateService.new(user: user, account: account, village: village).perform
          else
            puts "account: #{account.username} - #{village.name}: không có công trình nào trong hàng chờ"
          end
        end
      end
    end
  end
end
