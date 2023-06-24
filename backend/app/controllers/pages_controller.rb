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

  def get_same_university_books
    current_user = User.find_by(id: params[:current_user_id])
    if current_user && current_user.first_choice_school
      first_choice_school_books = Book.joins(favorite_books: :user)
                                        .where("users.first_choice_school = ?",current_user.first_choice_school)
                                        .group(:book_id)
                                        .order("count(favorite_books.id) DESC")
                                        .limit(5)
                                        .includes([:reviews])
    end
    if current_user && current_user.second_choice_school
      second_choice_school_books = Book.joins(favorite_books: :user)
                                        .where("users.first_choice_school = ?",current_user.second_choice_school)
                                        .group(:book_id)
                                        .order("count(favorite_books.id) DESC")
                                        .limit(5)
                                        .includes([:reviews])
    end
    if current_user && current_user.third_choice_school
      third_choice_school_books = Book.joins(favorite_books: :user)
                                        .where("users.first_choice_school = ?",current_user.third_choice_school)
                                        .group(:book_id)
                                        .order("count(favorite_books.id) DESC")
                                        .limit(5)
                                        .includes([:reviews])
    end
    books = {
      first_choice_school_books: first_choice_school_books,
      second_choice_school_books: second_choice_school_books,
      third_choice_school_books: third_choice_school_books
    }
    books.compact!
    if books
      render json: books, include: "reviews"
    end
  end

end
