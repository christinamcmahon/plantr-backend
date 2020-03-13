module Api::V1
  class UsersController < ApplicationController
    before_action :find_user, only: [:show, :edit, :update, :destroy]
    skip_before_action :authorized, only: [:create]

    def index
      @users = User.all
      render json: @users
    end

    def show
      render json: @user
    end

    def new
      @user = User.new
    end

    def profile
      render json: { user: UserSerializer.new(current_user) }, status: :accepted
    end

    def create
      @user = User.create(
        username: params[:user][:username],
        password: params[:user][:password],
        name: params[:user][:name],
        avatar_url: params[:user][:avatar_url],
        email: params[:user][:email],
        notification: params[:user][:notification],
      )
      byebug
      if @user.valid?
        @token = encode_token({ user_id: @user.id })
        render json: { user: UserSerializer.new(@user), jwt: @token }, status: :created
      else
        render json: { error: "failed to create user" }, status: :not_acceptable
      end
    end

    def destroy
      @user.destroy
    end

    def update
      @user.update(user_params)
      render json: @user
    end

    private

    def find_user
      @user = User.find(params[:id])
    end

    def user_params
      params.permit(:name, :username, :password, :avatar_url, :email, :notification)
    end
  end
end
