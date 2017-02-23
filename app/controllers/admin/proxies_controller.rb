class Admin::ProxiesController < Admin::BaseController

  def create
    Clone::CloneProxyService.new(content: params[:prox][:content]).perform
  end

  def new

  end
end
