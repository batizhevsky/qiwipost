module QiwiPost
  class Station < Struct.new(:metrostationsname, :town, :latitude, :longitude)
    
    # 
    # Создает объект Station из xml
    # @param  xml Nokogiri::XML::Element 
    # 
    # @return Station Станция метро
    def self.build_from xml
      station = Station.new 
      station.metrostationsname = xml.at_xpath('metrostationsname').text
      station.town = xml.at_xpath('town').text
      station.latitude = xml.at_xpath('latitude').text
      station.longitude = xml.at_xpath('longitude').text
      return station
    end
  end
end
