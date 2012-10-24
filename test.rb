#encoding: utf-8
$:.unshift File.dirname('__FILE__')

require 'lib/qiwipost'
require 'date'
qiwipost = QiwiPost.new(number: '9876543210', password: 'test', test: true)


# puts File.open('/tmp/pdf.pdf', 'w') {|f| f.write qiwipost.get_package_sticker([14344100085949, 14344100085958]) } 

# builder = Nokogiri::XML::Builder.new do |xml|
#   xml.paczkomaty {
#     # xml.packcode [14344100085949, 14344100085958]
#     [14344100085949, 14344100085958].each do |id|
#       xml.pack {
#         puts id
#         xml.packcode id
#       }
#     end
#   }
# end

# @network = QiwiPost::Network.new(qiwipost)

# puts @network.post_and_get_response("getsticker", packcode[]: 14344100085949, packcode[]: 14344100085958])
pack = QiwiPost::DeliveryPackage.new
pack.id = 1
pack.adreseePhoneNumber= 9879689618
pack.senderPhoneNumber= 9876543210
pack.boxMachineName= "MSC_036"
pack.alternativeBoxMachineName= "MSC_039"

pack.packType= :C
pack.onDeliveryAmount= 0
puts qiwipost.create_delivery_packs(false, pack)

 puts res = qiwipost.create_delivery_packs(false, pack)

#14344100085949
#14344100085958
puts Date.new(2012,9,10)
#puts qiwipost.get_payment_info(Date.new(2012,9,2), Date.new(2012,10,2))


