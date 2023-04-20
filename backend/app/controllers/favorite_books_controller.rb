class FavoriteBooksController < ApplicationController

  include RecordChecker

  def show
    current_user = User.find_by(id: params[:user_id])
    book = Book.find_by(id: params[:book_id])
    if !exist_favorite_book?(current_user, book)
      render json: true
    else
      render json: false
    end

  end

  def create
    current_user = User.find_by(id: params[:user_id])
    book = Book.find_by(id: params[:book_id])
    favorite_book = current_user.favorite_books.new(book_id: book.id)
    if favorite_book
      favorite_book.save
      render json: favorite_book, status: 200
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end

  def destroy
    current_user = User.find_by(id: params[:user_id])
    book = Book.find_by(id: params[:book_id])
    favorite_book = current_user.favorite_books.find_by(book_id: book.id)
  if favorite_book.destroy
      render json: { status: :ok }
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end


end
