#encoding: utf-8
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
    # Вписок всех терминалов
    # 
    # @return Array Массив объектов QiwiPost::Postomat
    def list_machines
      machines_xml = list_machines_row
      parse_machines_list_to_array machines_xml
    end

    # 
    # 3 ближайших терминала от почтового кода в радиусе 10 километров
    # @param  postcode Integer Почтовый код
    # 
    # @return Array Массив объектов QiwiPost::Postomat
    def list_machines_near_poscode postcode
      machines_xml = list_machines_near_poscode_row postcode
      parse_machines_list_to_array machines_xml
    end

    # 
    # Информация о 3 ближайших терминалах в радиусе 10 км от указанной станции метрополитена
    # @param  town String Название города, напр.: "Москва"
    # @param  station String Название странции, напр.: "ВДНХ"
    # 
    # @return Array Массив объектов QiwiPost::Postomat
    def list_machines_near_metro town, station
      machines_xml = list_machines_near_metro_row town, station
      parse_machines_list_to_array machines_xml
    end

    # 
    # Поиск терминала по его уникальному идентификатору
    #
    # @param  machine_id String Уникальный идентификатор терминала
    # 
    # @return Array Массив объектов QiwiPost::Postomat
    def find_machine_by_id machine_id
      machines_xml = find_machine_by_id_row machine_id
      parse_machines_list_to_array machines_xml
    end


    ###########################
    ###### Сырые методы ######
    ###########################

    # 
    # Список всех терминалов в сыром виде
    # По умолчанию возвращает xml
    # Используйте listmachines(format: :csv) для выгрузки :csv
    # @param  args Hash format: 'xml' или format: 'csv'
    # 
    # @return String Возвращает ответ сервера
    def list_machines_row(args = {format: :xml} )
      format = args[:format]
      raise ArgumentError ":format must be :csv or :xml only" unless [:csv, :xml].include?(format )
      response = post_and_get_response('listmachines_'+format.to_s)
      error = find_error_in(response, 'paczkomaty')
      raise QiwiPost::Exceptions::ErrorRecivedExecption, error if error 
      return response
    end

    # 
    # 3 ближайших терминала от почтового кода в радиусе 10 километров 
    # в сыром виде
    # @param  postcode Integer Почтовый код
    # 
    # @return String Возвращает ответ сервера (xml)
    def list_machines_near_poscode_row postcode
      response = post_and_get_response("findnearestmachinesbypostcode&postcode=#{postcode}", postcode: postcode)
      error = find_error_in(response, 'paczkomaty')
      raise QiwiPost::Exceptions::ErrorRecivedExecption, error if error 
      return response
    end

    # 
    # Информация о 3 ближайших терминалах в радиусе 10 км от указанной станции метрополитена
    # в сыром виде
    # @param  town String Название города, напр.: "Москва"
    # @param  station String Название странции, напр.: "ВДНХ"
    # 
    # @return String Возвращает ответ сервера (xml)
    def list_machines_near_metro_row town, station
      response = post_and_get_response("findnearestmachinesbymetrostatnion&stationname=#{station}&town=#{town}", 
                              town: town, stationname: station)
      error = find_error_in(response, 'paczkomaty')
      raise QiwiPost::Exceptions::ErrorRecivedExecption, error if error 
      return response
    end

    # 
    # Поиск терминала по его уникальному идентификатору
    # в сыром виде
    # @param  machine_id String Уникальный идентификатор терминала
    # 
    # @return String Возвращает ответ сервера (xml)
    def find_machine_by_id_row machine_id
      response = post_and_get_response("findmachinebyname&name=#{machine_id}", name: machine_id)
      error = find_error_in(response, 'paczkomaty')
      raise QiwiPost::Exceptions::ErrorRecivedExecption, error if error 
      return response
    end

    private    
    def post_and_get_response post_to, options={}
      auth_params = { telephonenumber: self.number, password: @password }
      host = "#{self.host}/?do=#{post_to}"
      url = URI.parse(URI.encode host)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      req = Net::HTTP::Post.new(url.request_uri)
      req.set_form_data(auth_params.merge(options))
      return http.request(req).body
    end

    # def get_response post_to, options={}
    #   auth_params = { telephonenumber: self.number, password: @password }
    #   url = URI.parse(self.host+'/?do='+post_to)
    #   http = Net::HTTP.new(url.host, url.port)
    #   http.use_ssl = true
    #   http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    #   req = Net::HTTP::Post.new(url.request_uri)
    #   puts auth_params.merge(options)
    #   req.set_form_data(auth_params.merge(options))
    #   return http.request(req).body
    # end


    def find_error_in xml, root_element
      document =  Nokogiri::XML(xml)
      error = document.at_xpath("//#{root_element}/error")
      error.text if error
    end

    def parse_machines_list_to_array xml
      document = Nokogiri::XML(xml).root
      machines = []
      document.xpath("/paczkomaty/machine").each do |machine|
        postomat = QiwiPost::Postomat.new
        if (node = machine.at_xpath('name'))
          postomat.name = node.text
        end
        if node = machine.at_xpath('postcode')
          postomat.postcode = node.text
        end
        if node = machine.at_xpath('street')
          postomat.street = node.text
        end
        if node = machine.at_xpath('buildingnumber')
          postomat.buildingnumber = node.text
        end
        if node = machine.at_xpath('town')
          postomat.town = node.text
          end
        if node = machine.at_xpath('latitude')
          postomat.latitude = node.text
          end
        if node = machine.at_xpath('longitude')
          postomat.longitude = node.text
          end
        if (node = machine.at_xpath('locationdescription'))
          postomat.locationdescription = node.text
        end
        machines << postomat
      end
      return machines
    end
  end
end