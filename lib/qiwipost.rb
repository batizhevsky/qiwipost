module QiwiPost
  API_URL = "https://api.qiwipost.ru"
  TEST_API_URL = "https://apitest.qiwipost.ru/"
  DATEFORMAT = "%F"

  require 'rubygems'
  require 'date'
  require 'net/http'
  require 'net/https'
  require 'nokogiri'


  require_relative 'qiwi_post/client'
  require_relative 'qiwi_post/delivery_package'
  require_relative 'qiwi_post/exeptions'
  require_relative 'qiwi_post/list_machines'
  require_relative 'qiwi_post/network'
  require_relative 'qiwi_post/postomat'
  require_relative 'qiwi_post/package_status'
  require_relative 'qiwi_post/package'
  require_relative 'qiwi_post/payment'
  require_relative 'qiwi_post/station'

end
