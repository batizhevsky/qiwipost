module QiwiPost
  class Package < Struct.new(:id, :adreseePhoneNumber, :senderPhoneNumber)
  end
end