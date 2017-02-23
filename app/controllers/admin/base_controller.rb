class Admin::BaseController < ApplicationController
  # common behavior goes here ...
  before_filter :verify_admin

  def current_ability
    @current_ability ||= AdminAbility.new(current_user)
  end
  private
  def verify_admin
    redirect_to root_url unless current_user.try(:is_admin?)
  end
end
