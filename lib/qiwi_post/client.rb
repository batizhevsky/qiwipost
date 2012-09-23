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
      machines_xml = QiwiPost::ListMashines.new(self).list_machines_near_metro_row(town, station)
      QiwiPost::ListMashines.create_array_from machines_xml
    end

    # 
    # Поиск терминала по его уникальному идентификатору
    #
    # @param  machine_id String Уникальный идентификатор терминала
    # 
    # @return Array Массив объектов {QiwiPost::Postomat}
    def find_machine_by_id machine_id
      machines_xml = QiwiPost::ListMashines.new(self).find_machine_by_id_row machine_id
      QiwiPost::ListMashines.create_array_from machines_xml
    end

    # 
    # Cтатус посылки 
    # для расшифровки статусов используйте {QiwiPost::PackageStatus#status_list} 
    # @param  packcode String Уникальный идентификатор посылки
    # 
    # @return Symbol Статус посылки
    def get_package_status packcode
      QiwiPost::PackageStatus.new(self).with_code(packcode)
    end

    
    # 
    # Получение информации о посылках
    # @param  *filter Hash Параметры фильтрации(необязательные)
    #  :status - Фильтрации по статусу. Используйте {QiwiPost::PackageStatus#status_list} 
    #  :startdate - Начальная дата для формирования списка(формат: ГГГГ-ММ-ДД)
    # :enddate - Конечная дата для формирования списка(формат: ГГГГ-ММ-ДД)
    # :confirmed - Подтвержденные или не подтвержденные отпрадения (Boolean)
    # 
    # @return [type] [description]
    def get_all_packages(*filter)
      packages = QiwiPost::PackageStatus.new(self).all(filter)
      QiwiPost::PackageStatus.to_array packages
    end

    # 
    # Получение информации о наложенных платежах
    # @param  start_date String Начальная дата для формирования списка(необ)
    # @param  end_date String Конечная дата для формирования списка(необ)
    # 
    # @return String Информация о наложенных платежах
    def get_payment_info(start_date=nil, end_date=nil)
      packages = QiwiPost::PackageStatus.new(self).payment_info(start_date, end_date)
      #TODO Сделать парсинг в объекты
    end

    def create_delivery_packs(*params)
      pack_info = params[0]

    end
  end
end