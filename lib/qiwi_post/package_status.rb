#encoding: utf-8
module QiwiPost
  class PackageStatus
    def initialize client
      @network = QiwiPost::Network.new client
    end

    # Cтатус посылки 
    # для расшифровки статусов используйте {QiwiPost::PackageStatus#status_list} 
    # @param  packcode String Уникальный идентификатор посылки
    # 
    # @return Symbol Статус посылки
    def with_code packcode
      response = @network.post_and_get_response("fgetpackstatus&packcode=#{packcode}", packcode: packcode)
      error = QiwiPost::Exceptions.find_error_in(response, 'paczkomaty')
      puts response
      raise QiwiPost::Exceptions::ErrorRecivedExecption, error if error
      Nokogiri::XML(response).at_xpath('//at_xpath/status').text.to_s
    end

    # 
    # Получение информации о посылках
    # @param  *filter Hash Параметры фильтрации(необязательные)
    #  :status - Фильтрации по статусу. Используйте {QiwiPost::PackageStatus#status_list} 
    #  :startdate - Начальная дата для формирования списка(формат: ГГГГ-ММ-ДД)
    # :enddate - Конечная дата для формирования списка(формат: ГГГГ-ММ-ДД)
    # :confirmed - Подтвержденные или не подтвержденные отпрадения (Boolean)
    # 
    # @return [type] [description]
    def all *filter
      #TODO: Сделать парсинг аргументов
      response = @network.post_and_get_response("getpacksbysender")
      error =  QiwiPost::Exceptions.find_error_in(response, 'paczkomaty/customer')
      raise QiwiPost::Exceptions::ErrorRecivedExecption, error if error
      return response
    end

    # 
    # Получение информации о наложенных платежах
    # @param  start_date String Начальная дата для формирования списка(необ)
    # @param  end_date String Конечная дата для формирования списка(необ)
    # 
    # @return String Информация о наложенных платежах
    def payment_info(start_date=nil, end_date=nil)
      #TODO: Сделать парсинг аргументов
      response = @network.post_and_get_response("getcodreport", startdate: start_date, enddate: end_date)
      error =  QiwiPost::Exceptions.find_error_in(response, 'paczkomaty/customer')
      raise QiwiPost::Exceptions::ErrorRecivedExecption, error if error
      return response
    end

    # 
    #  Статусы посылки
    # 
    # @return Hash Ключ: Статус в QiwiPost, Значение: Разъяснение
    def self.status_list
      statuses = {
        Created: "Посылка создана в IT-системе компании QIWI Post.",
        Prepared: "Посылка подготовлена (оплачена и подтверждена) в IT-системе компании QIWI Post, но еще не доставлена в сортировочный центр.",
        Sent: "Посылка доставлена в сортировочный центр компании QIWI Post.",
        InTransit: "Посылка направлена в терминал.",
        Stored: "Посылка размещена в терминале.",
        Delivered: "Посылка доставлена получателю.",
        Avizo: "Получатель не забрал посылку терминала в течение 3 суток.",
        Expired: "Посылка просрочена к получению.",
        RetunedToAgency: "Посылка отправлена в пункт выдачи просроченных заказав (ПВЗ).",
        DeliveredToAgency: "Посылка доставлена в ПВЗ.",
        ReturnedToSortingCenter: "Посылка отправлена обратно в сортировочный центр.",
        DeliveredToSortingCenter: "Посылка доставлена в сортировочный центр.",
        ReturnedTosender: "Посылка возвращена отправителю.",
        Cancelled: "Посылка аннулирована."
      }
    end
  end
end
