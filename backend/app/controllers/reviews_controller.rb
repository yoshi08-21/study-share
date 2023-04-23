class ReviewsController < ApplicationController

  def index
    reviews = Review.all
    if reviews
      render json: reviews
    else
      render json: reviews.erorrs
    end
  end


end
