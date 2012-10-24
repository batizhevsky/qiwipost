module QiwiPost
  class Network
    def initialize client
      @number = client.number
      @password = client.password
      @host = client.host
    end

    def post_and_get_response post_to, options={}
      auth_params = { telephonenumber: @number, password: @password }
      host = "#{@host}/?do=#{post_to}"
      connection(host, auth_params.merge(options)) 
    end

    private

    def connection host, params
      url = URI.parse(URI.encode host)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      req = Net::HTTP::Post.new(url.request_uri)
      req.set_form_data(params)
      http.request(req).body
    end
  end
end