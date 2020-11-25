class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :find_user, only: :create
  before_action :find_relation, only: :destroy

  def create
    current_user.follow @user
    response_user
  end

  def destroy
    current_user.unfollow @user
    response_user
  end

  private

  def find_user
    @user = User.find_by id: params[:followed_id]
    return if @user

    flash[:danger] = t ".user_not_found"
    redirect_to root_path
  end

  def find_relation
    @user_relationship = Relationship.find_by id: params[:id]
    return @user = Relationship.find_by(id: params[:id]).followed if @user_relationship

    flash[:danger] = t ".user_not_found"
    redirect_to root_path
  end

  def response_user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end
end
