class Clone::CloneProxyService
  attr_reader :args

  def initialize args
    @content = args[:content]
  end

  def perform
    @array = @content.split("\n")
    @array.each do |item|
      if item.first.numeric?
        i = item.split("\t")
        Proxy.create! id: i[0], port: i[1].to_i
      end
    end
  end
end
