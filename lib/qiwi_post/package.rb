module QiwiPost
  class Package < Struct.new(:packcode, :packsize, :amountcharged,
                             :paymentstatus, :creationdate, :labelcreationtime,
                             :status, :is_conf_printed, :labelprinted,
                             :ondeliveryamount, :preferedboxmachinename,
                             :alternativeboxmachinename)
    def self.to_package xml
      pack = Package.new
      if (node = xml.at_xpath('packcode'))
        pack.packcode = node.text
      end
      if (node = xml.at_xpath('packsize'))
        pack.packsize = node.text
      end

      if (node = xml.at_xpath('amountcharged'))
        pack.amountcharged = node.text
      end
      if (node = xml.at_xpath('paymentstatus'))
        pack.paymentstatus = node.text
      end
      if (node = xml.at_xpath('creationdate'))
        pack.creationdate = node.text
      end
      if (node = xml.at_xpath('labelcreationtime'))
        pack.labelcreationtime = node.text
      end
      if (node = xml.at_xpath('status'))
        pack.status = node.text
      end
      if (node = xml.at_xpath('is_conf_printed'))
        pack.is_conf_printed = node.text
      end
      if (node = xml.at_xpath('labelprinted'))
        pack.labelprinted = node.text
      end
      if (node = xml.at_xpath('ondeliveryamount'))
        pack.ondeliveryamount = node.text
      end
      if (node = xml.at_xpath('preferedboxmachinename'))
        pack.preferedboxmachinename = node.text
      end
      if (node = xml.at_xpath('alternativeboxmachinename'))
        pack.alternativeboxmachinename = node.text
      end
      return pack
    end
  end
end
