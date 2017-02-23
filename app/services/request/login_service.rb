class Request::LoginService
  attr_reader :args

  def initialize args
    @current_user = args[:current_user]
    @server = args[:server]
    @name = args[:name]
    @password = args[:password]
  end

  def perform
    url = "http://#{@server}/dorf1.php"
    p = Hash.new
    p[:name] = @name
    p[:password] = @password
    p[:login] = Time.now.to_i
    if @current_user.is_admin?
      HTTP.post url, form: p
    else
      HTTP.via(@ip, @port).post url, form: p
    end
  end
end
