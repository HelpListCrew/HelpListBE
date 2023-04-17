class Api::V1::Users::SearchController < Api::ApiController
  def index
    user = User.find_recipient_by_username(params[:username])
    if params[:username].blank?
      raise ActionController::BadRequest
    elsif user == []
      render json: { data: {} }
    else
      render json: UserSerializer.new(user)
    end
  end
end