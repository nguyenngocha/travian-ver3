class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  # before_action :check_valid_proxy
  def current_time
    Time.now.to_i
  end

  private
  def check_valid_proxy
    if current_user.ip.nil?
      redirect_to error_path
    else
      unless Check::CheckActiveProxyService.new(ip: current_user.ip, port: current_user.port).perform?
        redirect_to error_path
      end
    end
  end
end
