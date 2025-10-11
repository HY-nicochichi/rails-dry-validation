module Rails
  module Dry
    module Validation

      module Concern
        extend ActiveSupport::Concern

        class_methods do
          def validate_params_with(schema, action:)
            alias_method "original_#{action}".to_sym, action 
            private "original_#{action}".to_sym
            define_method(action) do |*args|
              return gen_valid_data(schema) do |valid_data|
                @valid_data = valid_data
                send("original_#{action}".to_sym, *args)
              end
            end
          end
        end

        def gen_valid_data(schema)
          result = schema.new.call(
            params.to_unsafe_h.except(:controller, :action, :format)
          )
          if result.success?
            yield result.to_h
          else
            return render json: {msg: 'Validation failed', detail: result.errors.to_h}, status: 422
          end
        end
      end

    end
  end
end
