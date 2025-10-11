require 'rails'

module Rails
  module Dry
    module Validation

      class Railtie < ::Rails::Railtie
        initializer 'rails-dry-validation.action_controller' do
          ActiveSupport.on_load(:action_controller) do
            include Rails::Dry::Validation::Concern
          end
        end
      end
      
    end
  end
end
