class Api::V1::Organizations::UsersController < Api::ApiController
  def index
    render json: UserSerializer.new(Organization.find(params[:id]).users)
  end
end