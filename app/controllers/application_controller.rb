class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :authenticate_user!

  def current_time
    Time.now.to_i
  end

  private
  def check_valid_proxy
    unless Check::GetActiveProxyService.new(current_user: current_user).perform?
      redirect_to error_path
    end
  end
end
