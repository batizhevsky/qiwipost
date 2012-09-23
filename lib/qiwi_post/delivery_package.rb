module QiwiPost
  
  # 
  # Класс для создания отправления в QiwiPost
  # 
  class DeliveryPackage < Struct.new(:id, :adreseePhoneNumber, :senderPhoneNumber,
                             :boxMachineName, :packType, :onDeliveryAmount,
                             :customerRef)
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
        next if m == :customerRef
        raise QiwiPost::Exceptions::ArgumentExecption, "#{m.to_sym} cant be nil" if self[m].nil?
      end
      return true
    end

  end
end