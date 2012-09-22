module QiwiPost
  class Package < Struct.new(:id, :adreseePhoneNumber, :senderPhoneNumber)
  end
end

#    <pack>
    #     <packcode>14344100068441</packcode>
    #     <packsize>A</packsize>
    #     <amountcharged>0.00</amountcharged>
    #     <calculatedchargeamount>111.00</calculatedchargeamount>
    #     <paymentstatus>NotApplicable</paymentstatus>
    #     <creationdate>2012-09-14T11:53:31.992+04:00</creationdate>
    #     <labelcreationtime></labelcreationtime>
    #     <customerdeliveringcode>0</customerdeliveringcode>
    #     <status>Cancelled</status>
    #     <is_conf_printed></is_conf_printed>
    #     <labelprinted></labelprinted>
    #     <receiveremail>9876543210</receiveremail>
    #     <ondeliveryamount>0.00</ondeliveryamount>
    #     <preferedboxmachinename>MOB_003</preferedboxmachinename>
    #     <alternativeboxmachinename></alternativeboxmachinename>
    # </pack>