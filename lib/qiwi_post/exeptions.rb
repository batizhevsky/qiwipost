module QiwiPost
  module Exceptions
    class QiwipostError < StandardError
      attr_reader :data
      def initialize(data)
        @data = data
        super
      end
    end

    class AuthenticationException < QiwipostError; end

    class SyntaxException < QiwipostError; end

    class ErrorRecivedExecption < QiwipostError; end
    
  end
end