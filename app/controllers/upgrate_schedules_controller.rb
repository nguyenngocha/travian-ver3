class UpgrateSchedulesController < ApplicationController
  before_action :load_account
  before_action :load_village
  before_action :load_upgrate_building, only: :destroy

  def new
    @upgrate_building = @village.upgrate_schedules.build
  end

  def create
    @upgrate_building = @village.upgrate_schedules.build upgrate_building_params
    if @upgrate_building.save
      flash[:success] = "add success"
      redirect_to account_villages_path
    else
      flash[:fail] = "add fail"
      render :new
    end
  end

  def destroy
    @upgrate_building.destroy
    redirect_to account_villages_path(@account)
  end

  private
  def load_village
    @village = @account.villages.find_by id: params[:village_id]
    if @village.nil?
      flash[:dangder] = "không tìm thấy village"
      redirect_to account_villages_path(@account)
    end
  end

  def load_account
    @account = current_user.accounts.find_by id: params[:account_id]
    redirect_to accounts_path if @account.nil?
  end

  def upgrate_building_params
    params.require(:upgrate_schedule).permit :upgrate_id, :village_id
  end

  def load_upgrate_building
    @upgrate_building = @village.upgrate_schedules.find_by id: params[:id]
    if @upgrate_building.nil?
      flash[:dangder] = "không tìm thấy upgrate building"
      redirect_to account_village_upgrate_schedules_path(@account, @village)
    end
  end
end
