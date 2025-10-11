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
    required(:password).filled(:string, size?: 8..20)
    required(:name).filled(:string, size?: 1..30)
  end
end

# <Your Rails App>/app/controllers/user_controller.rb
class UserController < ApplicationController
  validate_params_with UserCreateSchema, action: :create

  def create
    user = User.create!(@valid_data) 
    render json: user.as_json, status: 201
  end
end
```
