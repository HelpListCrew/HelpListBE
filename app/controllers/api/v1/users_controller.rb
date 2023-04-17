class Api::V1::UsersController < Api::ApiController
	def index
		render json: UserSerializer.new(User.all)
	end

	def show
		user = User.find(params[:id])
		if user
			render json: UserSerializer.new(user), status: 201
		else
			render json: ErrorSerializer.new(user).user_error, status: 404
		end
	end

  def create
    user = User.new(user_params)
# require 'pry'; binding.pry
		if user.save
    	render json: UserSerializer.new(user), status: 201
		else
			render json: ErrorSerializer.new(user).user_error, status: 404
    end
  end

  def destroy
   User.destroy(params[:id])
   render status: 204
  end

	def update
		user = User.find(params[:id])

		if user.update(user_params)
			render json: UserSerializer.new(user), status: 201
		else
			render json: ErrorSerializer.new(user).user_error, status: 400

		end
	end

	def login_user
		user = User.find_by(email: user_params[:email])
		if user && user.authenticate(user_params[:password])
			render json: UserSerializer.new(user), status: 201
		elsif user && user_params[:uid] == user.uid
			render json: UserSerializer.new(user), status: 201
		else
			render json: ErrorSerializer.failed_auth, status: 401
		end
	end

  private
	def user_params
		params.require(:user).permit(:uid, :email, :password, :user_type, :username)
	end
end