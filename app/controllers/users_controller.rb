class UsersController < ApplicationController

  before_action :authenticate!, only: [:edit, :update]

  def new
    # @user = User.friendly.find(params[:user_id])
    @user = User.new
  end

  def create
    # @user = User.friendly.find(params[:user_id])
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "You've created a new user."
      redirect_to root_path
    else
      flash[:danger] = @user.errors.full_messages
      render new
    end
  end

  def edit
    @user = User.friendly.find(params[:id])
    authorize @user
  end

  def update
    # @user = User.friendly.find(params[:user_id])
    @user = User.friendly.find(params[:id])
    authorize @user
    # binding.pry
    if @user.update(user_params)
      flash[:success] = "You've updated the user."

      redirect_to edit_user_path(@user)
    else
      flash[:danger] = @user.errors.full_messages
      redirect_to edit_user_path(@user)

    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :image, :username)
    end

  end
