#encoding: utf-8
$:.unshift File.dirname('__FILE__')

require 'lib/qiwipost'

qiwipost = QiwiPost.new(number: '9876543210', password: 'test')

# puts QiwiPost::PackageStatus.new(qiwipost).all
#puts qiwipost.get_payment_info "2012-08-02", "2012-08-03"

# puts qiwipost.get_all_packages(status: :Prepared, startdate: "2012-09-01")
# # Prepared
# 
pack = QiwiPost::DeliveryPackage.new
pack.id = 1
pack.adreseePhoneNumber= 1
pack.senderPhoneNumber= 1
pack.boxMachineName= 1
pack.packType= 1
pack.onDeliveryAmount= 1
puts pack.check_presence

