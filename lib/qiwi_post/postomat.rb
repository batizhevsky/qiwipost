module QiwiPost
  class Postomat < Struct.new(:name, :postcode, :street,
                              :buildingnumber, :town, :latitude, 
                              :longitude, :locationdescription )
    def to_hash
      Hash[*members.zip(values).flatten]
    end
  end
end