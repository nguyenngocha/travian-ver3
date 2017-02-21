class AccountsController < ApplicationController
  # before_action :check_valid_proxy
  before_action :check_valid_proxy, :check_correct_account, only: :create
  before_action :find_account, only: [:show, :edit, :update, :destroy]
  def index
    @servers = Server.all
    @accounts = current_user.accounts
  end

  def show
    res = Request::LoginService.new(ip: current_user.ip, port: current_user.port,
      server: @account.server_id, name: @account.username,
      password: @account.password).perform
    page = Nokogiri::HTML res.body.to_s
    if page.css("div#header ul#navigation").empty?
      flash[:danger] = "Co loi khi dang nhap tai khoan nay"
      redirect_to accounts_path
    else
      Login::UpdateVillageService.new(current_account: @account, page: page).perform?
    end
  end

  def destroy
    if @account.destroy
      flash[:success] = "Delete success"
      redirect_to accounts_path
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    byebug
  end

  def create
    @account = current_user.accounts.build account_params
    if @account.save
      flash[:success] = "Them tai khoan thanh cong"
    else
      flash[:danger] = "Them tai khoan that bai"
    end
    redirect_to accounts_path
  end

  private
  def account_params
    params.require(:account).permit(:username, :password, :server_id, :t3e, :race,
      :sess_id, :ajax_token, :player_uuid)
  end

  def check_correct_account
    res = Request::LoginService.new(ip: current_user.ip, port: current_user.port,
      server: params[:account][:server_id], name: params[:account][:username],
      password: params[:account][:password]).perform
    page = Nokogiri::HTML res.body.to_s
    if page.css("div#header ul#navigation").empty?
      flash[:danger] = "Co loi khi dang nhap tai khoan nay"
      redirect_to accounts_path
    else
      parse_cookies res.cookies.cookies, page
    end
  end

  def parse_cookies cookies, page
    @cookies = Hash.new
    cookies.each do |cookie|
      params[:account][cookie.name.downcase.to_sym] = cookie.value
    end
    params[:account][:race] = if page.css("div.playerName img.nation1").present?
      "romans"
    elsif page.css("div.playerName img.nation2").present?
      "teutons"
    elsif page.css("div.playerName img.nation3").present?
      "gauls"
    end

    array = page.css("script").first.child.text.gsub(/\n\t/, '').
      gsub(/ = '/, ',').gsub(/'\;/, ',').gsub(/,\n/, '').split(',')
    hash = Hash[*array]
    params[:account][:ajax_token] = hash["window.ajaxToken"]
    params[:account][:player_uuid] = hash["window._player_uuid"]
  end

  def find_account
    @account = current_user.accounts.find params[:id]
    redirect_to accounts_path if @account.nil?
  end
end
