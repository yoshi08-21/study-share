class BrowsingHistoriesController < ApplicationController

  def index
    current_user = User.find_by(id: params[:current_user_id])
    book_browsing_histories = current_user.watched_books
    review_browsing_histories = current_user.watched_reviews.includes(:user)
    question_browsing_histories = current_user.watched_questions.includes(:user, :book)

    if current_user
      render json: {
        book_browsing_histories: book_browsing_histories,
        review_browsing_histories: review_browsing_histories.as_json(include: :user),
        question_browsing_histories: question_browsing_histories.as_json(include: [:user, :book]),
      }
    else
      render json: { error: "エラーが発生しました" }
    end
  end

end
