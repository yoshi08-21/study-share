class ReviewsController < ApplicationController

  def index
    book = Book.find_by(id: params[:book_id])
    reviews = book.reviews.includes(:user)
    if reviews
      render json: reviews, include: "user"
    else
      render json: reviews.errors
    end
  end

  def show
    current_user = User.find_by(id: params[:current_user_id])
    book = Book.find_by(id: params[:book_id])
    review = Review.includes(:user).find_by(id: params[:id])
    if review
      render json: {
        book: book,
        review: review.as_json(include: :user),
      }
      if current_user && !exist_review_browsing_history?(current_user, review)
        save_review_browsing_history(current_user, review)
      end
    else
      render json: review.errors
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

  def update
    review = Review.find_by(id: params[:id])
    current_user = User.find_by(id: params[:current_user_id])
    author = review.user
    if validate_authorship(current_user, author)
      if review.update(review_params)
        render json: review, status: 200
      else
        render json: { error: "エラーが発生しました" }, status: 400
      end
    else
      render json: { error: "権限がありません" }, status: 400
    end
  end

  def destroy
    review = Review.find_by(id: params[:id])
    current_user = User.find_by(id: params[:current_user_id])
    author = review.user
    if validate_authorship(current_user, author)
      if review.destroy
        head :no_content
      else
        render json: { error: "エラーが発生しました" }, status: 400
      end
    else
      render json: { error: "権限がありません" }, status: 400
    end
  end

  def new_reviews
    reviews = Review.includes(:user, :book).order("created_at DESC").limit(5)
    if reviews
      render json: reviews, include: [:user, :book]
    else
      render json: reviews.errors
    end
  end

  def is_favorite
    current_user = User.find_by(id: params[:user_id])
    review = Review.find_by(id: params[:review_id])
    favorite_review = FavoriteReview.find_by(user_id: current_user.id, review_id: review.id) if current_user
    if favorite_review
      render json: { is_favorite: true, favorite_review_id: favorite_review.id }
    else
      render json: false
    end
  end


  private

    def review_params
      params.require(:review).permit(:title, :content, :rating, :user_id, :book_id)
    end

    def exist_review_browsing_history?(current_user, review)
      current_user.watched_reviews.include?(review)
    end

    def save_review_browsing_history(current_user, review)
      review_browsing_histories = BrowsingHistory.where(user_id: current_user.id).where.not(review_id: nil)
      max_browsing_histories = 10
      if review_browsing_histories.count >= max_browsing_histories
        review_browsing_histories.first.destroy
        current_user.browsing_histories.create(review_id: review.id)
      else
        current_user.browsing_histories.create(review_id: review.id)
      end
    end


end
