module QiwiPost

  # Информация о наложенных платежах
  # @attr [String]  boxmachinename Идентификатор терминала
  # @attr [String]  comissionforcod Комиссия за наложенный платеж
  # @attr [String]  dateofparceldelivered Дата получения посылки
  # @attr [String]  id Внешний идентификатор посылки
  # @attr [String]  parcelbarcode Уникальный код посылки, присвоенный системой
  # @attr [String]  pricefordelivery Стоимость доставки
  # @attr [String]  receivedcod Полученная сумма денег
  class Payment < Struct.new(:boxmachinename, :comissionforcod, :dateofparceldelivered, :id,
                             :parcelbarcode, :pricefordelivery, :receivedcod)

    def self.to_object xml
      pay = Payment.new
      if (node = xml.at_xpath('boxmachinename'))
        pay.boxmachinename = node.text
      end
      if (node = xml.at_xpath('comissionforcod'))
        pay.comissionforcod = node.text
      end
      if (node = xml.at_xpath('dateofparceldelivered'))
        pay.dateofparceldelivered = node.text
      end
      if (node = xml.at_xpath('id'))
        pay.id = node.text
      end
      if (node = xml.at_xpath('parcelbarcode'))
        pay.parcelbarcode = node.text
      end
      if (node = xml.at_xpath('pricefordelivery'))
        pay.pricefordelivery = node.text
      end
      if (node = xml.at_xpath('receivedcod'))
        pay.receivedcod = node.text
      end
      pay
    end
  end

end
