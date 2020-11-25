class FollowersController < ApplicationController
  before_action :find_user

  def index
    @title = t ".follower"
    @users = @user.followers
                  .page(params[:page]).per Settings.paginate.number_of_page
    render "users/show_follow"
  end
end
