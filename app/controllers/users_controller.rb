class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new show create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find_by id: params[:id]
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
     @user = User.new
  end

   def create
    @user = User.new(user_params) # Not the final implementation!
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url

    else
      render :new
    end
  end

  def edit
    @user = User.find_by id: params[:id]
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile Updated"
      redirect_to @user
      # Handle a successful update.
    else
      render :edit
    end
  end

  def destroy
    user = User.find_by(id: params[:id])
    if user&.destroy
      flash[:success] = "User deleted"
    else
      flash[:danger] = "Delete fail!"
    end
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user  = User.find_by(id: params[:id])
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = "Followers"
    @user = User.find_by(id: params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  # Before filters
  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in first"
      redirect_to login_url
    end
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find_by(id: params[:id])
    return if current_user?(@user)
    flash[:danger] = " Access Denied : Unauthorized Access"
    redirect_to(root_url)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
