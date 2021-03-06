class Api::V1::AuthController < ApplicationController
  # skip_before_action :authorized, only: [:create, :profile]

  def show
    user = current_user
    if logged_in?
      render json: { id: user.id, username: user.username }
    else
      render json: {error: 'No user could be found'}, status: 401
    end
  end

  # Login
  def create
    # byebug
    @user = User.find_by(username: user_login_params[:username])
    #User#authenticate comes from BCrypt
    if @user && @user.authenticate(user_login_params[:password])
      # encode token comes from ApplicationController
      token = encode_token({ user_id: @user.id })
      render json: { user: UserSerializer.new(@user), jwt: token, plants: @user.plants }, status: :accepted
    else
      render json: { message: "Invalid username or password" }, status: :unauthorized
    end
  end

  private

  def user_login_params
    # params { user: {username: 'Chandler Bing', password: 'hi' } }
    params.require(:user).permit(:username, :password)
  end
end
