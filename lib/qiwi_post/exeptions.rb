module QiwiPost
  module Exceptions
    class QiwiPostError < StandardError
      attr_reader :data
      def initialize(data)
        @data = data
        super
      end
    end

    class AuthenticationException < QiwiPostError; end

    class SyntaxException < QiwiPostError; end

    class ErrorRecivedExecption < QiwiPostError; end

    class ArgumentExecption < QiwiPostError; end
    
    def self.find_error_in xml, root_element
      document =  Nokogiri::XML(xml)
      error = document.at_xpath("//#{root_element}/error")
      error.text if error
    end

  end
end