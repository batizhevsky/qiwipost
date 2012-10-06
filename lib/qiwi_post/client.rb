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
      @network = QiwiPost::Network.new(self)
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
    # @param  *filter Hash Параметры фильтрации
    #(необязательные)
    #  :status - Фильтрации по статусу. Используйте {QiwiPost::PackageStatus#status_list}
    #  :startdate Date Начальная дата для формирования списка
    #  :enddate Date Конечная дата для формирования списка
    #  :confirmed - Подтвержденные или не подтвержденные отпрадения (Boolean)
    #
    # @return [type] [description]
    def get_all_packages(*filter)
      packages = QiwiPost::PackageStatus.new(self).all(filter)
      QiwiPost::PackageStatus.to_array packages, Package.new
    end

    #
    # Получение информации о наложенных платежах
    # @param  start_date Date Начальная дата для формирования списка(необ)
    # @param  end_date Date Конечная дата для формирования списка(необ)
    #
    # @return Array Информация о наложенных платежах. Массив объектов {QiwiPost::Payment}
    #
    def get_payment_info(start_date=nil, end_date=nil)
      packages = QiwiPost::PackageStatus.new(self).payment_info(start_date, end_date)
      QiwiPost::PackageStatus.to_array packages, Payment.new
    end

    #
    # Создание посылок
    # @param  pack_info Boolean Aвтоматически установить статус Prepared (true) или Created(false).
    # Второй вариант означает необходимость создания этикетки для посылки
    # @param  *packages DeliveryPackage
    #
    # @return Array Возращает массив объектов QiwiPost::DeliveryPackage с новыми полями packcode и calculatedcharge.
    # в случае ошибки ErrorRecivedExecption
    def create_delivery_packs(autolabels, *packages)
      #TODO: Перенести куда нибудь
      raise QiwiPost::Exceptions::ArgumentExecption, "Должна быть хотя бы одна посылка" if packages.count < 1
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.paczkomaty {
          xml.autoLabels autolabels ? 1 : 0
          packages.each do |pack|
            xml.pack {
              xml.id_ pack.id
              xml.adreseePhoneNumber pack.adreseePhoneNumber
              xml.senderPhoneNumber pack.senderPhoneNumber
              xml.boxMachineName pack.boxMachineName
              xml.packType pack.packType
              xml.onDeliveryAmount pack.onDeliveryAmount
              xml.customerRef pack.customerRef
            }
          end
        }
      end
      response = @network.post_and_get_response("createdeliverypacks", content: builder.to_xml)

      packages.each do |pack|
        resp = Nokogiri::XML(response).root.at_xpath("//paczkomaty/pack[id[contains(text(), #{pack.id}\)]]")
        if err = resp.at_xpath("error")
          pack.error = err.text
          next
        end
        pack.packcode = resp.at_xpath("packcode").text
        pack.calculatedcharge = resp.at_xpath("calculatedcharge").text
      end

      error = QiwiPost::Exceptions.find_error_in(response, 'paczkomaty/pack')
      raise QiwiPost::Exceptions::ErrorRecivedExecption, error if error

      return packages
    end
    #
    # Отмена создания посылки
    # @param  packcode Integer Уникальный код посылки
    #
    # @return Boolean Возвращает true если посылка удалена или возбуждает исключение
    def cancel_package packcode
      response = @network.post_and_get_response("cancelpack", packcode: packcode)
      error = QiwiPost::Exceptions.find_error_in(response, 'paczkomaty')
      raise QiwiPost::Exceptions::ErrorRecivedExecption, error if error
      return true
    end

    def change_packsize packcode, packsize
      response = @network.post_and_get_response("change_packsize", packcode: packcode, packsize: packsize)
      error = QiwiPost::Exceptions.find_error_in(response, 'paczkomaty')
      raise QiwiPost::Exceptions::ErrorRecivedExecption, error if error
      return true
    end

    # Подтверждение о передаче посылки к отправлению
    # Только для посылок со статусом :Prepared
    # @param  test Boolean Тестовая распечатка.
    # @param  *packcodes Integer Уникальный код посылки. Можно передавать несколько.
    #
    # @return String PDF файл с распечаткой
    def confirm_printout test, *packcodes
      raise QiwiPost::Exceptions::ArgumentExecption, "Должна быть хотя бы одна посылка" if packcodes.count < 1
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.paczkomaty {
          xml.testprintout test ? 1 : 0
          packcodes.each do |packcode|
            xml.pack {
              xml.packcode packcode
            }
          end
        }
      end
      response = @network.post_and_get_response("getconfirmprintout", content: builder.to_xml)
      error = QiwiPost::Exceptions.find_error_in(response, 'paczkomaty')
      raise QiwiPost::Exceptions::ErrorRecivedExecption, error if error
      return response
    end

    #
    # Получение ярлыка на посылку в формате PDF
    # @param  packcode String Уникальный код посылки
    # @param  label String Тип этикетки.
    # По умолчанию 3шт на А4
    # "A6P" - этикетка A6 книжной ориентации
    #
    # @return String PDF файл с этикетками
    def get_package_sticker packcode, label=nil
      response = @network.post_and_get_response("getsticker", packcode: packcode, labelType: label)
      error = QiwiPost::Exceptions.find_error_in(response, 'paczkomaty')
      raise QiwiPost::Exceptions::ErrorRecivedExecption, error if error
      return response
    end

    #
    # Добавление или изменение дополнительной информации о посылке
    # @param  packcode String Уникальный код посылки
    # @param  ref String Дополнительная информация, указываемая на этикетке. По умолчанию пустая
    #
    # @return String PDF файл с этикетками
    def change_customer_ref packcode, ref=nil
      response = @network.post_and_get_response("setcustomerref", packcode: packcode, customerRef: ref)
      error = QiwiPost::Exceptions.find_error_in(response, 'paczkomaty')
      raise QiwiPost::Exceptions::ErrorRecivedExecption, error if error
      return true
    end

    #
    # Оплата посылки (в случае использования собственного ярлыка).
    # @param  packcode String Уникальный код посылки
    #
    # @return Boolean Возвращает true если запрос успешно обработан
    def payforpack packcode
      response = @network.post_and_get_response("payforpack", packcode: packcode)
      error = QiwiPost::Exceptions.find_error_in(response, 'paczkomaty')
      raise QiwiPost::Exceptions::ErrorRecivedExecption, error if error
      return true
    end

    #
    # Прайс-лист
    #
    # @return Hash :A,:B,:C - цены по размеру отправлений. :on_delivery  - надбавка за наложенный платеж
    def pricelist
      response = @network.post_and_get_response("pricelist")
      error = QiwiPost::Exceptions.find_error_in(response, 'paczkomaty')
      raise QiwiPost::Exceptions::ErrorRecivedExecption, error if error
      prices = {}
      doc = Nokogiri::XML(response).root
      prices[:on_delivery] = doc.at_xpath("on_delivery_payment").text
      doc.xpath('packtype').each do |pack|
        prices[pack.at_xpath("type").text.to_sym] = pack.at_xpath("price").text
      end
      return prices
    end
    #
    # Список станций метрополитена для выбранного города
    # @param  town String Город
    #
    # @return Array Массив объектов {Qiwipost::Station}
    def get_all_metrostations town
      response = @network.post_and_get_response("getallmetrostations&town=#{town}", town: town)
      error = QiwiPost::Exceptions.find_error_in(response, 'paczkomaty')
      raise QiwiPost::Exceptions::ErrorRecivedExecption, error if error
      stations = []
      Nokogiri::XML(response).xpath('//paczkomaty/station').each do |station|
        stations << Station.build_from(station)
      end
      return stations
    end
  end
end
