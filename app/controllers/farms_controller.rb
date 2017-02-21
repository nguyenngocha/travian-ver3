class FarmsController < ApplicationController
  before_action :find_account, :find_farm_list

  def new
    @farm = Farm.new
  end

  def create
    @farm = @farm_list.farms.build farm_params
    if @farm.save
      flash[:success] = "Create success"
      redirect_to edit_account_farm_list_path @account, @farm_list
    else
      render :new
    end
  end

  def destroy
    @farm = @farm_list.farms.find params[:id]
    if @farm && @farm.destroy
      flash[:success] = "Destroy success"
      redirect_to edit_account_farm_list_path @account, @farm_list
    else
      redirect_to account_farm_lists_path @account
    end
  end

  private
  def farm_params
    params.require(:farm).permit(:x, :y, :army1, :army2, :army3, :army4, :army5,
      :army6, :army7, :army8, :army9, :army10, :army11)
  end

   def find_account
    @account = current_user.accounts.find params[:account_id]
    redirect_to accounts_path if @account.nil?
  end

  def find_farm_list
    @farm_list = @account.farm_lists.find params[:farm_list_id]
    redirect_to account_farm_lists_path(@account) if @farm_list.nil?
  end
end
