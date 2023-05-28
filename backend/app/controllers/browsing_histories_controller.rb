class BrowsingHistoriesController < ApplicationController

  def index
    current_user = User.find_by(id: params[:current_user_id])
    book_browsing_histories = current_user.watched_books
    review_browsing_histories = current_user.watched_reviews.includes(:user)
    if current_user
      render json: {
        book_browsing_histories: book_browsing_histories,
        review_browsing_histories: review_browsing_histories.as_json(include: :user)
      }
    else
      render json: { error: "エラーが発生しました" }
    end
  end

end
