class UsersController < ApplicationController

  def new
    @user = User.find_by(id: params[:user_id])
    @user = User.new
  end

  def create
    @user = User.find_by(id: params[:user_id])
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
    @user = User.find_by(id: params[:id])

  end

  def update
    @user = User.find_by(id: params[:user_id])
    @user = User.find_by(id: params[:id])

    if @user.update(user_params)
      flash[:success] = "You've updated the user."

      redirect_to topics_path(@user)
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
