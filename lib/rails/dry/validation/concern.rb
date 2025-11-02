module Rails
  module Dry
    module Validation

      module Concern
        extend ActiveSupport::Concern

        class_methods do
          def validate_params_with(schema, action:)
            before_action -> { exec_validation(schema) }, only: [action]
          end
        end
        
        private def exec_validation(schema)
          validated = schema.new.call(
            params.to_unsafe_h.except(:controller, :action, :format)
          )
          if validated.success?
            @valid_data = validated.to_h
          else
            return render json: {msg: "Validation failed", detail: validated.errors.to_h}, status: 422
          end
        end
      end

    end
  end
end
