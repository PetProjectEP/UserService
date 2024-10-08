class SessionsController < ApplicationController
  before_action :set_session, only: %i[ show destroy ]

  # Returns user by auth_token in get param
  def show
    if @session
      @user = Rails.cache.fetch(@session[:user_id]) do
        User.find(@session[:user_id]).slice(:id, :name, :surname) # No need for storing any sensetive info
      end

      render json: @user.to_json(only: %i[id name surname])
    else
      render json: { error: "Token is invalid" }, status: :unprocessable_entity
    end
  end

  def create
    @user = User.find_by(nickname: auth_params[:nickname])

    if @user && @user.authenticate(auth_params[:password])
      @session = Session.new(user_id: @user.id)

      if @session.save
        render json: @session, status: :created, location: @session
      else
        render json: @session.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Authentication data are invalid" }, status: :unprocessable_entity
    end 
  end

  def destroy
    unless @session
      render json: { error: "Session cant be found" }, status: :unprocessable_entity
    end

    if @session.destroy!
      render json: { success: "Session is terminated" }
    else
      render json: @session.errors, status: :unprocessable_entity
    end
  end

  private
    def set_session
      @session = Session.find(params[:id])
    end

    def auth_params
      params.require(:user).permit(:nickname, :password)
    end
end
