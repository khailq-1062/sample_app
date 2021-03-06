class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create)
  before_action :find_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.activate
                 .page(params[:page]).per Settings.paginate.number_of_page
  end

  def new
    @user = User.new
  end

  def show
    @microposts = @user.microposts
                       .includes([:image_attachment])
                       .page(params[:page]).per Settings.paginate.number_of_page
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".check_mail"
      redirect_to root_url
    else
      flash[:danger] = t ".danger"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".user_updated"
      redirect_to @user
    else
      flash[:danger] = t ".user_update_false"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".user_deleted"
    else
      flash[:danger] = t ".user_delete_err"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit User::USER_PERMIT
  end

  def correct_user
    redirect_to current_user unless current_user? @user
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".user_not_found"
    redirect_to root_path
  end
end
