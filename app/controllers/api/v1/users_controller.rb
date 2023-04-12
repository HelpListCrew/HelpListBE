class Api::V1::UsersController < ApplicationController
  def create
    user = User.new(user_params)

    if user.save
      render json: UserSerializer.new(user), status: 201
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :user_type)
    end
end