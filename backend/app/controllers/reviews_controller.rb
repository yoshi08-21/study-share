class ReviewsController < ApplicationController

  def index
    book = Book.find_by(id: params[:book_id])
    reviews = book.reviews.includes(:user)
    if reviews
      render json: reviews, include: "user"
    else
      render json: reviews.erorrs
    end
  end

  def show
    book = Book.find_by(id: params[:book_id])
    review = Review.includes(:user).find_by(id: params[:id])
    if review
      render json: {
        book: book,
        review: review.as_json(include: :user),
      }
    else
      render json: review.erorrs
    end
  end

  def update
    review = Review.find_by(id: params[:id])
    if review.update(review_params)
      render json: review, status: 200
    else
      render json: { error: "エラーが発生しました" }, status: 400
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

  def destroy
    review = Review.find_by(id: params[:id])
    if review.destroy
      head :no_content
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end

  def new_reviews
    reviews = Review.all
    # 後でレビューの並び替え・件数の制限を実装する
    if reviews
      render json: reviews
    else
      render json: reviews.erorrs
    end

  end

  private

    def review_params
      params.require(:review).permit(:title, :content, :rating, :user_id, :book_id)
    end

end
