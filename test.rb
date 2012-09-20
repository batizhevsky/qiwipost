$:.unshift File.dirname('__FILE__')

require 'lib/qiwipost'

qiwipost = QiwiPost.new(number: '4876543210', password: 'tes2t', test: true)
puts qiwipost.listmachines