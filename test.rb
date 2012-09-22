#encoding: utf-8
$:.unshift File.dirname('__FILE__')

require 'lib/qiwipost'

qiwipost = QiwiPost.new(number: '4876543210', password: 'test')

puts qiwipost.find_machine_by_id "MSC_026"