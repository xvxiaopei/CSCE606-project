class UsersController < ApplicationController
  def show
    if session[:user_id] == nil
      flash[:warning] = "please login"
      redirect_to '/login'
      return
    end
    @user = User.find(session[:user_id])
    @submissions = @user.submissions.paginate(page: params[:page])
    # debugger
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Handle a successful save.
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to '/profile'
    else
      render 'new'
    end
  end


  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation,:provider,:uid,:oauth_token,:oauth_expires_at)
    end
end
