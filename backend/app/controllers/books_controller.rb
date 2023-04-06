class BooksController < ApplicationController

  def index
    books = Book.all
    if books
      render json: books
    else
      render json: books.errors
    end
  end

end
