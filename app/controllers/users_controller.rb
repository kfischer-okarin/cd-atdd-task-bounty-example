class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to new_user_path, notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def login_form
    # This action will render the login form
  end

  def login
    @user = User.find_by(name: params[:name])
    if @user
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Successfully logged in."
    else
      flash.now[:alert] = "User not found: #{params[:name]}"
      render :login_form, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
