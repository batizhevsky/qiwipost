#encoding: utf-8
$:.unshift File.dirname('__FILE__')

require 'lib/qiwipost'

qiwipost = QiwiPost.new(number: '9876543210', password: 'test')

# puts QiwiPost::PackageStatus.new(qiwipost).all
#puts qiwipost.get_payment_info "2012-08-02", "2012-09-03"

puts qiwipost.get_all_metrostations 'Москва'
# # Prepared
# 
# 
#puts qiwipost.list_machines
# # 
# pack = QiwiPost::DeliveryPackage.new
# pack.id = 1
# pack.adreseePhoneNumber= 9879689618
# pack.senderPhoneNumber= 9876543210
# pack.boxMachineName= "MSC_039"
# pack.packType= :C
# pack.onDeliveryAmount= 0



# pack1 = QiwiPost::DeliveryPackage.new
# pack1.id = 2
# pack1.adreseePhoneNumber= 9879689618
# pack1.senderPhoneNumber= 9876543210
# pack1.boxMachineName= "MOB_039"
# pack1.packType= :A
# pack1.onDeliveryAmount= 0

# puts res = qiwipost.create_delivery_packs(true, pack, pack1)
# res.each{ |pack| puts pack.error?}


#puts qiwipost.get_package_sticker(24344100054129)
# qiwipost.change_customer_ref(14344100054129, "fdfdfsf dsfsd")

# f= File.new('/tmp/test.pdf', 'w')
# f << qiwipost.get_package_sticker(14344100054129)
# f.close
