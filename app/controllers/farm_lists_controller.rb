class FarmListsController < ApplicationController
  before_action :find_account
  before_action :find_farm_list, only: [:edit, :update, :destroy]
  def index
    @villages = @account.villages
    @farm_list = FarmList.new
    @farm_lists = @account.farm_lists
  end

  def edit
    @villages = @account.villages
    @farms = @farm_list.farms
  end

  def create
    @farm_list = @account.farm_lists.new create_params
    if @farm_list.save
      flash[:success] = "Create success"
    else
      flash[:danger] = "Create false"
    end
    redirect_to account_farm_lists_path(@account)
  end

  def update
    if @farm_list.update_attributes update_params
      flash[:success] = "Update success"
      redirect_to edit_account_farm_list_path @account, @farm_list
    else
      redirect_to root_path
    end
  end

  def destroy
    if @farm_list.destroy
      flash[:success] = "Destroy success"
      redirect_to account_farm_lists_path(@account)
    end
  end

  private
  def create_params
    params.require(:farm_list).permit(:id, :name, :village_id)
  end

  def find_account
    @account = current_user.accounts.find params[:account_id]
    redirect_to accounts_path if @account.nil?
  end

  def find_farm_list
    @farm_list = @account.farm_lists.find params[:id]
    redirect_to account_farm_lists_path(@account) if @farm_list.nil?
  end

  def update_params
    params.require(:farm_list).permit(:id, :name, :status,
      farms_attributes: [:id ,:army1, :army2, :army3, :army4, :army5, :army6, :army7,
      :army8, :army9, :army10, :army11, :status])
  end
end
