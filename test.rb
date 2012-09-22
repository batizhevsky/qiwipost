#encoding: utf-8
$:.unshift File.dirname('__FILE__')

require 'lib/qiwipost'

qiwipost = QiwiPost.new(number: '9876543210', password: 'test', test: true)

# puts QiwiPost::PackageStatus.new(qiwipost).all
puts qiwipost.get_payment_info "2012-08-02", "2012-08-03"

