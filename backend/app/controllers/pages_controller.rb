class PagesController < ApplicationController

  def new_reviews
    reviews = Review.includes(:user, :book).order("created_at DESC").limit(5)
    if reviews
      render json: reviews, include: [:user, :book]
    else
      render json: reviews.errors
    end
  end

  def popular_books
    books = Book.includes(:reviews, :favorite_books)
                  .select("books.*, (SELECT COUNT(*) FROM reviews WHERE reviews.book_id = books.id) AS reviews_count, (SELECT ROUND(AVG(reviews.rating), 1) FROM reviews where reviews.book_id = books.id) AS average_rating, (SELECT COUNT(*) FROM favorite_books WHERE favorite_books.book_id = books.id) AS favorite_books_count")
                  .group("books.id")
                  .order("favorite_books_count DESC")
                  .limit(5)
    if books
      render json: books, include: "reviews"
    else
      render json: books.errors
    end
  end


end
