class BooksController < ApplicationController
  include RecordChecker

  def index
    books = Book.all
    if books
      render json: books
    else
      render json: books.errors
    end
  end

  def show
    book = Book.find_by(id: params[:id])
    if book
      render json: book
    else
      render json:book.errors
    end
  end

  def is_favorite
    current_user = User.find_by(id: params[:user_id])
    book = Book.find_by(id: params[:book_id])
    favorite_book = FavoriteBook.find_by(user_id: current_user.id, book_id: book.id)
    if favorite_book
      render json: { is_favorite: true, favorite_book_id: favorite_book.id }
    else
      render json: false
    end
  end

end
