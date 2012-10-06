#encoding: utf-8
$:.unshift File.dirname('__FILE__')

require 'lib/qiwipost'
require 'date'
qiwipost = QiwiPost.new(number: '9876543210', password: 'test')

puts Date.new(2012,9,10)
#puts qiwipost.get_payment_info(Date.new(2012,9,2), Date.new(2012,10,2))


