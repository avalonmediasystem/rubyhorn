module Rubyhorn::RestClient
  module Exceptions
    class RubyhornException < StandardError
    end

    class ServerError < RubyhornException
      attr_reader :status_code
      def initialize(status_code)
        @status_code = status_code
        super("Server responded with status code: #{status_code}.")
      end
    end

    class MissingRequiredParams < RubyhornException
      attr_reader :params
      def initialize(params)
        @params = params
        super("You failed to include #{params.join(', ')} in your request.")
      end
    end

    class HTTPNotFound < RubyhornException
      def initialize
        super("Not found")
      end
    end
    
  end
end
