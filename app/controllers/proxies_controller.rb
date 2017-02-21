class ProxiesController < ApplicationController
  def create
    Clone::CloneProxyService.new(content: params[:proxy][:content]).perform
  end

  def new

  end
end
