namespace :job do
  desc "Farm"
  task farm: [:environment] do
    # @users = User.all
    User.each do |user|
      # accounts = user.accounts
      user.accounts.each do |account|
        account.farm_lists.each do |farm_list|
          if farm_list.status
            Farm::FarmService.new(user: user, account: account, farm_list: farm_list ).perform
          end
        end
      end
    end
  end
end
