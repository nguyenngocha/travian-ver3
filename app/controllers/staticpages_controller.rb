class StaticpagesController < ApplicationController
  skip_before_filter :authenticate_user!
  def home
  end

  def error

  end
end
