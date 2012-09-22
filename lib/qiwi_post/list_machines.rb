module QiwiPost
  class ListMashines


    def initialize client
      @network = QiwiPost::Network.new client
    end

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
      response = @network.post_and_get_response('listmachines_'+format.to_s)
      error = QiwiPost::Exceptions.find_error_in(response, 'paczkomaty')
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
      response = @network.post_and_get_response("findnearestmachinesbypostcode&postcode=#{postcode}", postcode: postcode)
      error = QiwiPost::Exceptions.find_error_in(response, 'paczkomaty')
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
      response = @network.post_and_get_response("findnearestmachinesbymetrostatnion&stationname=#{station}&town=#{town}", 
                              town: town, stationname: station)
      error = QiwiPost::Exceptions.find_error_in(response, 'paczkomaty')
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
      response = @network.post_and_get_response("findmachinebyname&name=#{machine_id}", name: machine_id)
      error = QiwiPost::Exceptions.find_error_in(response, 'paczkomaty')
      raise QiwiPost::Exceptions::ErrorRecivedExecption, error if error 
      return response
    end

    def self.create_array_from xml
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