module Rails
  module Dry
    module Validation

      module Concern
        rescue_from Rails::Dry::Validation::ValidationFailed, with: :render_validation_failed

        def render_validation_failed(error)
          render json: {msg: error.message, detail: error.detail}, status: 422
        end

        def validate_data(data = {}, schema: nil)
          data_hash = case data
                      when ActionController::Parameters
                        data.to_unsafe_h.except(:controller, :action, :format)
                      when Hash
                        data.except("controller", "action", "format")
                      else
                        raise Rails::Dry::Validation::InvalidData.new("In validate_data, data must be params/hash")
                      end
          unless schema&.ancestors&.include?(Dry::Validation::Contract)
            raise Rails::Dry::Validation::InvalidSchema.new("In validate_data, schema must extend Dry::Validation::Contract")
          end
          result = schema.new.call(data_hash)
          if result.success?
            result.to_h
          else
            raise Rails::Dry::Validation::ValidationFailed.new("Validation failed", result.errors.to_h)
          end
        end
      end

    end
  end
end
