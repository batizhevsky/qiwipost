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

    attr_reader :password

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
      raise QiwiPost::Exceptions::AuthenticationException, ":number is not equeal 10 numbers" if @number.length != 10 
      options[:test] ? @host = QiwiPost::TEST_API_URL : @host = QiwiPost::API_URL
      #TODO: пробная авторизация
    end

    # 
    # Вписок всех терминалов
    # 
    # @return Array Массив объектов QiwiPost::Postomat
    def list_machines
      machines_xml = QiwiPost::ListMashines.new(self).list_machines_row
      QiwiPost::ListMashines.create_array_from machines_xml
    end

    # 
    # 3 ближайших терминала от почтового кода в радиусе 10 километров
    # @param  postcode Integer Почтовый код
    # 
    # @return Array Массив объектов QiwiPost::Postomat
    def list_machines_near_poscode postcode
      machines_xml = QiwiPost::ListMashines.new(self).list_machines_near_poscode_row postcode
      QiwiPost::ListMashines.create_array_from machines_xml
    end

    # 
    # Информация о 3 ближайших терминалах в радиусе 10 км от указанной станции метрополитена
    # @param  town String Название города, напр.: "Москва"
    # @param  station String Название странции, напр.: "ВДНХ"
    # 
    # @return Array Массив объектов QiwiPost::Postomat
    def list_machines_near_metro town, station
      machines_xml = QiwiPost::ListMashines.new(self).list_machines_near_metro_row town, station
      QiwiPost::ListMashines.create_array_from machines_xml
    end

    # 
    # Поиск терминала по его уникальному идентификатору
    #
    # @param  machine_id String Уникальный идентификатор терминала
    # 
    # @return Array Массив объектов QiwiPost::Postomat
    def find_machine_by_id machine_id
      machines_xml = QiwiPost::ListMashines.new(self).find_machine_by_id_row machine_id
      QiwiPost::ListMashines.create_array_from machines_xml
    end

   
  end
end