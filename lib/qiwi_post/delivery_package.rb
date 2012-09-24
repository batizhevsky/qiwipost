module QiwiPost
  
  # 
  # Класс для создания отправления в QiwiPost
  # 
  class DeliveryPackage < Struct.new(:id, :adreseePhoneNumber, :senderPhoneNumber,
                             :boxMachineName, :packType, :onDeliveryAmount,
                             :customerRef, :packcode, :calculatedcharge)

    def error=(err)
      @error = err
    end

    def error
      @error
    end

    def error? 
      return !@error.nil?
    end

    def to_hash
      Hash[*members.zip(values).flatten]
    end
   

    # 
    # Проверяет наличие всех аргументов
    # кроме customerRef
    # бросает QiwiPost::Exceptions::ArgumentExecption 
    # если =nil
    # 
    # @return Boolean Возвращает true в случае успеха
    def check_presence
      members.each do |m|
        next if [:customerRef, :packcode, :calculatedcharge].include? m
        raise QiwiPost::Exceptions::ArgumentExecption, "#{m.to_sym} cant be nil" if self[m].nil?
      end
      return true
    end

    def to_xml
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.pack {
          xml.id_ self.id
          xml.adreseePhoneNumber self.adreseePhoneNumber
          xml.senderPhoneNumber self.senderPhoneNumber
          xml.boxMachineName self.boxMachineName
          xml.packType self.packType
          xml.onDeliveryAmount self.onDeliveryAmount
          xml.customerRef self.customerRef
        }
      end
      builder.doc.root.to_xml
    end

  end
end