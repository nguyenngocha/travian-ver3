class SessionsController < Devise::SessionsController
  # after_action :check_proxy, only: [:create]
  skip_before_filter :authenticate_user!
  def new
    super
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:success, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message! :success, :signed_out if signed_out
    yield if block_given?
    respond_to_on_destroy
  end

  private
  # def check_proxy
  #   unless  Check::GetActiveProxyService.new(current_user: current_user).perform?
  #     redirect_to error_path
  #   end
  # end
end
