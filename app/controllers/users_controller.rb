class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
  end

  def new
     @user = User.new
  end

   def create
    @user = User.new(user_params) # Not the final implementation!
    if @user.save
      flash[:success] = t "welcome_to_the_sample_app!"
      redirect_to @user
      # Handle a successful save.

    else
      render :new
    end
  end

private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

end
