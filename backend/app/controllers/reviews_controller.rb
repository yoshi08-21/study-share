class ReviewsController < ApplicationController
  include SharedActions::AttachImage
  include SharedActions::DateTime

  def index
    book = Book.find_by(id: params[:book_id])
    reviews = Review.includes(book: { image_attachment: :blob }, user: { image_attachment: :blob })
                    .select("reviews.*, (SELECT COUNT(*) FROM favorite_reviews WHERE favorite_reviews.review_id = reviews.id) AS favorite_reviews_count")
                    .where(book_id: book.id)
    reviews_with_images = attach_image_to_reviews(reviews)

    if reviews_with_images
      render json: reviews_with_images
    else
      render json: reviews_with_images.errors
    end
  end

  def show
    current_user = User.find_by(id: params[:current_user_id])
    book = Book.with_attached_image
                .select("books.*, (SELECT COUNT(*) FROM reviews WHERE reviews.book_id = books.id) AS reviews_count, (SELECT ROUND(AVG(reviews.rating), 1) FROM reviews where reviews.book_id = books.id) AS average_rating, (SELECT COUNT(*) FROM favorite_books WHERE favorite_books.book_id = books.id) AS favorite_books_count, (SELECT COUNT(*) FROM questions WHERE questions.book_id = books.id) AS questions_count")
                .find_by(id: params[:book_id])
    if book.image.attached?
      image_url = rails_blob_url(book.image)
    end
    book_json = book.as_json.merge(image: image_url)

    review = Review.select("reviews.*, (SELECT COUNT(*) FROM favorite_reviews WHERE favorite_reviews.review_id = reviews.id) AS favorite_reviews_count")
                    .find_by(id: params[:id])
    review_json = review.as_json
    review_json["created_at"] = format_japanese_time(review.created_at)

    review_user = User.with_attached_image.find_by(id: review.user_id)
    if review_user.image.attached?
      user_image_url = rails_blob_url(review_user.image)
    end
    review_user_json = review_user.as_json.merge(image: user_image_url)

    if review_json
      render json: {
        book: book_json,
        review: review_json,
        review_user: review_user_json
      }
      if current_user && !exist_review_browsing_history?(current_user, review)
        save_review_browsing_history(current_user, review)
      end
    else
      render json: review_json.errors
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

  def check_existence
    book = Book.find_by(id: params[:book_id])
    review = Review.find_by(id: params[:id])
    if book && review
      head :ok
    else
      head :not_found
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
