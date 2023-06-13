class BooksController < ApplicationController
  include RecordChecker

  def index
    books = Book.includes(:reviews).select("books.*, (SELECT COUNT(*) FROM reviews WHERE reviews.book_id = books.id) AS reviews_count, (SELECT ROUND(AVG(reviews.rating), 1) FROM reviews where reviews.book_id = books.id) AS average_rating")
    if books
      render json: books, include: "reviews"
    else
      render json: books.errors
    end
    # current_user = User.find_by(id: params[:current_user_id])
    # books = Book.includes(:favorite_books).all
    # books_with_favorites = books.map do |book|
    #   favorite_book = book.favorite_books.find_by(user_id: current_user.id)
    #   {
    #     id: book.id,
    #     name: book.name,
    #     # 他のBookモデルの属性も必要に応じて組み込む
    #     is_favorite: favorite_book.present?,
    #     favorite_book_id: favorite_book&.id
    #   }
    # book.as_json.merge(is_favorite: current_user.fav_books.include?(book))
    # end
    # if books_with_favorites
    #   render json: books_with_favorites
    # else
    #   render json: books_with_favorites.errors
    # end
  end

  def show
    current_user = User.find_by(id: params[:current_user_id])
    book = Book.find_by(id: params[:id])
    if book
      render json: book
      if current_user && !exist_book_browsing_history?(current_user, book)
        save_book_browsing_history(current_user, book)
      end
    else
      render json:book.errors
    end
  end

  def create
    current_user = User.find_by(id: params[:user_id])
    book = current_user.books.build(book_params)
    if book.image == ""
      book.image = "/images/no_image.png"
    end
    if book.save
      render json: book, status: 200
    else
      render json: { errors: book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    current_user = User.find_by(id: params[:current_user_id])
    book = Book.find_by(id: params[:id])
    author = book.user
    if validate_authorship(current_user, author)
      if book.update(book_params)
        render json: book, status: 200
      else
        render json: { error: "エラーが発生しました" }, status: 400
      end
    else
      render json: { error: "権限がありません" }, status: 400
    end
  end

  def destroy
    current_user = User.find_by(id: params[:current_user_id])
    book = Book.find_by(id: params[:id])
    author = book.user
    if validate_authorship(current_user, author)
      if book.destroy
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
    book = Book.find_by(id: params[:book_id])
    favorite_book = FavoriteBook.find_by(user_id: current_user.id, book_id: book.id) if current_user
    if favorite_book
      render json: { is_favorite: true, favorite_book_id: favorite_book.id }
    else
      render json: false
    end
  end

  def search_books
    search_books_keyword = params[:searchBooksKeyword]
    books = Book.where("name LIKE ?", "%#{search_books_keyword}%").or(Book.where("author LIKE ?", "%#{search_books_keyword}%")).or(Book.where("publisher LIKE ?", "%#{search_books_keyword}%")).or(Book.where("subject LIKE ?", "%#{search_books_keyword}%"))
    books_count = books.count
    if books
      render json: {
        books: books,
        books_count: books_count
      }
    else
      render json: { error: "検索結果がありません" }
    end
  end

  private

    def book_params
      params.require(:book).permit(:name, :author, :publisher, :subject, :image, :user_id)
    end

    def exist_book_browsing_history?(current_user, book)
      current_user.watched_books.include?(book)
    end

    def save_book_browsing_history(current_user, book)
      book_browsing_histories = BrowsingHistory.where(user_id: current_user.id).where.not(book_id: nil)
      max_browsing_histories = 10
      if book_browsing_histories.count >= max_browsing_histories
        book_browsing_histories.first.destroy
        current_user.browsing_histories.create(book_id: book.id)
      else
        current_user.browsing_histories.create(book_id: book.id)
      end
    end

end
