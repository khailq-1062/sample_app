class FollowingsController < ApplicationController
  before_action :find_user

  def index
    @title = t ".following"
    @users = @user.following
                  .page(params[:page]).per Settings.paginate.number_of_page
    render "users/show_follow"
  end
end
