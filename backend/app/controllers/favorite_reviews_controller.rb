class FavoriteReviewsController < ApplicationController

  def create
    current_user = User.find_by(id: params[:user_id])
    review = Review.find_by(id: params[:review_id])
    favorite_review = current_user.favorite_reviews.build(review_id: review.id)
    if !exist_favorite_review?(current_user, review)
      favorite_review.save
      render json: favorite_review, status: 200
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end

  def destroy
    current_user = User.find_by(id: params[:user_id])
    review = Review.find_by(id: params[:review_id])
    favorite_review = FavoriteReview.find_by(user_id: current_user.id, review_id: review.id)
    if favorite_review.destroy
      render json: { status: :ok }
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end


  private

    def exist_favorite_review?(current_user, review)
      current_user.fav_reviews.include?(review)
    end


end
