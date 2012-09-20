module QiwiPost
  def self.new(*args)
    QiwiPost::Client.new(args)
  end

  class Client

    #Номер телефона 
    attr_reader :number

    #адрес для подключения
    attr_reader :host

    # 
    # Создает объект 
    # Принимает параметры
    # :number - телефон в 10-ти значном виде
    # :password - пароль
    # :test - нобязательный параметр. yes для тестирования
    # @param  *args Hash :number, :password, :test 
    # 
    # @return [type] [description]
    def initialize(args)
      options = args[0]
      @number = options[:number] || (raise QiwiPost::Exceptions::AuthenticationException, ":number are required")
      @password = options[:password] || (raise QiwiPost::Exceptions::AuthenticationException, ":password are required")
      # номер телефона в 10-ти значном формате
      raise QiwiPost::Exceptions::AuthenticationException, ":number is not equeal 10 numbers" if @number.length != 10 
      options[:test] ? @host = QiwiPost::TEST_API_URL : @host = QiwiPost::API_URL
      #TODO: пробная авторизация
    end

    # 
    # Список всех терминалов
    # По умолчанию возвращает xml
    # Используйте listmachines(format: :csv) для выгрузки :csv
    # @param  args Hash format: 'xml' или format: 'csv'
    # 
    # @return String Возвращает ответ сервера
    def listmachines(args = {format: :xml} )
      format = args[:format]
      raise ArgumentError ":format must be :csv or :xml only" unless [:csv, :xml].include?(format )
      response = get_response('listmachines_'+format.to_s)
      error = find_error_in(response, 'paczkomaty')
      raise QiwiPost::Exceptions::ErrorRecivedExecption, error if error 
      return response
    end

    def list_machines_near_poscode postcode
    end

    def list_machines_near_metro town, station
    end

    def find_machine_by_id machine_id
    end

    

    private    
    def get_response post_to, options={}
      auth_params = { telephonenumber: self.number, password: @password }
      url = URI.parse(self.host+'/?do='+post_to)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      req = Net::HTTP::Post.new(url.request_uri)
      req.set_form_data(auth_params.merge(options))
      return http.request(req).body
    end

    def find_error_in xml, root_element
      document =  Nokogiri::XML(xml)
      error = document.at_xpath("//#{root_element}/error")
      error.text if error
    end
  end
end