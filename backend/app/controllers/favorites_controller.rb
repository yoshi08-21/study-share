class FavoritesController < ApplicationController

  def index
    current_user = User.find_by(id: params[:user_id])
    favorite_books = current_user.fav_books
    favorite_reviews = current_user.fav_reviews.includes(:user, :book)
    favorite_questions = current_user.fav_questions.includes(:user, :book)
    favorite_replies = current_user.fav_replies.includes(:user, :question)
    if current_user
      render json: {
        favorite_books: favorite_books,
        favorite_reviews: favorite_reviews.as_json(include: [:user, :book]),
        favorite_questions: favorite_questions.as_json(include: [:user, :book]),
        favorite_replies: favorite_replies.as_json(include: [:user, :question])
      },
      status: 200
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end

end
