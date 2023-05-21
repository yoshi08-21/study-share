class FavoritesController < ApplicationController

  def index
    current_user = User.find_by(id: params[:user_id])
    favorite_reviews = current_user.fav_reviews.includes(:user, :book)
    if current_user
      render json: {
        favorite_reviews: favorite_reviews.as_json(include: [:user, :book])
      },
      status: 200
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end

end
