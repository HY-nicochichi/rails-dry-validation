## rails-dry-validation
A schema based validation Gem for Rails params  
This Gem is inspired by FastAPI & Pydantic

## How to Use
``` ruby
# <Your Rails App>/config/routes.rb
Rails.application.routes.draw do
  post  "/user" => "user#create"
end

# <Your Rails App>/app/schemas/user_create_schema.rb
class UserCreateSchema < Dry::Validation::Contract
  params do
    required(:email).filled(:string, size?: 10..50, format?: /^[a-z0-9.-]+@[a-z0-9-]+\.[a-z0-9.-]+$/i)
    required(:password).filled(:string, size?: 8..20, format?: /^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])[a-zA-Z0-9]+$/i)
    required(:name).filled(:string, size?: 1..30)
  end
end

# <Your Rails App>/app/controllers/user_controller.rb
class UserController < ApplicationController
  def create
    valid_data = validate_data params, schema: UserCreateSchema

    user = User.create!(valid_data) 
    render plain: "User '#{valid_data[:name]}' created", status: 201
  end
end
```
