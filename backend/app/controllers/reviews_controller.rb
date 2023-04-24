class ReviewsController < ApplicationController

  def index
    reviews = Review.all
    if reviews
      render json: reviews
    else
      render json: reviews.erorrs
    end
  end

  def create
    current_user = User.find_by(id: params[:user_id])
    book = Book.find_by(id: params[:book_id])
    review = current_user.reviews.build(review_params)
    review.book_id = book.id
    if review.save
      render json: review, status: 200
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end

  private

    def review_params
      params.require(:review).permit(:title, :content, :rating, :user_id, :book_id)
    end

end
