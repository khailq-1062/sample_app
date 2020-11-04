class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      check_actived user
    else
      flash.now[:danger] = t ".login_false"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def check_actived user
    if user.activated?
      log_in user
      check_remember user
      redirect_back_or user
    else
      flash[:warning] = t ".not_active"
      redirect_to root_url
    end
  end
end
