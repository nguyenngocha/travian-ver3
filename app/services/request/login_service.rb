class Request::LoginService
  attr_reader :args

  def initialize args
    @ip = args[:ip]
    @port = args[:port]
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
    HTTP.via(@ip, @port).post url, form: p
  end
end
