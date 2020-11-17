class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @feed_items = current_user.feed
                              .includes([:user, :image_attachment])
                              .sort_by_date.page(params[:page])
                              .per Settings.paginate.number_of_page
  end

  def help; end

  def about; end

  def contact; end
end
