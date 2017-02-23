class VillagesController < ApplicationController
  before_action :find_account

  def index
    @villages = @account.villages
  end

  private
  def find_account
    @account = current_user.accounts.find params[:account_id]
    redirect_to accounts_path if @account.nil?
  end
end
