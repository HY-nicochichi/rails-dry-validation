require 'dry-validation'
require_relative 'validation/concern'
require_relative 'validation/railtie'

module Rails
  module Dry
    module Validation
  
      class Error < StandardError
      end

      class InvalidData < Error
      end

      class InvalidSchema < Error
      end

      class ValidationFailed < Error
        attr_reader :detail

        def initialize(message, detail)
          @detail = detail
          super(message)
        end
      end

    end
  end
end
