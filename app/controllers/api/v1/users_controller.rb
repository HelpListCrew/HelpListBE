class Api::V1::UsersController < Api::ApiController
	def index
		render json: UserSerializer.new(User.all)
	end

	def show
		render json: UserSerializer.new(User.find(params[:id]))
	end

  def create
    user = User.new(user_params)

		if user.save
    	render json: UserSerializer.new(user), status: 201
		else
			render json: ErrorSerializer.new(user).user_error, status: 404
    end
  end

  private
	def user_params
		params.require(:user).permit(:email, :password, :user_type)
	end
end