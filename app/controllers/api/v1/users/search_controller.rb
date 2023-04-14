class Api::V1::Users::SearchController < Api::ApiController
  def index
    user = User.find_recipient_by_email(params[:email])
    if user == []
      render json: { data: {} }
    else
      render json: UserSerializer.new(user)
    end
  end
end