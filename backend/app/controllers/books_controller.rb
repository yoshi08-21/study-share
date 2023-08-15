class BooksController < ApplicationController

  include RecordChecker
  require 'httparty'

  def index
    current_user_id = params[:current_user_id]
    books = Book.includes(:reviews)
                  .with_attached_image
                  .select("books.*, (SELECT COUNT(*) FROM reviews WHERE reviews.book_id = books.id) AS reviews_count, (SELECT ROUND(AVG(reviews.rating), 1) FROM reviews where reviews.book_id = books.id) AS average_rating, (SELECT COUNT(*) FROM favorite_books WHERE favorite_books.book_id = books.id) AS favorite_books_count, (SELECT COUNT(*) FROM favorite_books WHERE favorite_books.book_id = books.id and favorite_books.user_id = #{current_user_id}) AS check_favorite")

    books_with_images = books.map do |book|
      if book.image.attached?
        image_url = rails_blob_url(book.image)
      end
      book.as_json.merge(image: image_url)
    end
    if books_with_images
      render json: books_with_images, include: "reviews"
    else
      render json: books.errors
    end
  end

  def show
    current_user = User.find_by(id: params[:current_user_id])
    book = Book.includes(:reviews)
    .with_attached_image
    .select("books.*, (SELECT COUNT(*) FROM reviews WHERE reviews.book_id = books.id) AS reviews_count, (SELECT ROUND(AVG(reviews.rating), 1) FROM reviews where reviews.book_id = books.id) AS average_rating, (SELECT COUNT(*) FROM favorite_books WHERE favorite_books.book_id = books.id) AS favorite_books_count, (SELECT COUNT(*) FROM questions WHERE questions.book_id = books.id) AS questions_count")
    .find_by(id: params[:id])

    if book.image.attached?
      image_url = rails_blob_url(book.image)
    end
      book_json = book.as_json.merge(image: image_url)
    if book
      render json: book_json
      if current_user && !exist_book_browsing_history?(current_user, book)
        save_book_browsing_history(current_user, book)
      end
    else
      render json:book.errors
    end
  end

  def create
    current_user = User.find_by(id: params[:book][:user_id])
    book = current_user.books.build(book_params)
    if book.save
      unless book.image.attached?
        s3_object = Aws::S3::Resource.new.bucket('study-feedback-bucket').object('no image.png')

        temp_file = Tempfile.new('downloaded_image', binmode: true)
        temp_file.write(s3_object.get.body.read)
        temp_file.rewind

        book.image.attach(io: temp_file, filename: 'default_image.jpg', content_type: 'image/jpeg')
        temp_file.close
        temp_file.unlink
      end
      render json: book, status: 200
    else
      render json: { errors: book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    current_user = User.find_by(id: params[:book][:user_id])
    book = Book.find_by(id: params[:id])
    author = book.user
    if validate_authorship(current_user, author)
      if book.update(book_params)
        image_url = book.image.attached? ? rails_blob_url(book.image) : nil
        render json: { book: book, image_url: image_url }, status: 200
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
    # currentUserがnullの場合、デフォルト値の０が返ってくる
    current_user_id = params[:current_user_id]
    search_books_keyword = params[:searchBooksKeyword]
    books = Book.includes(:reviews, :favorite_books)
                .with_attached_image
                .select("books.*, (SELECT COUNT(*) FROM reviews WHERE reviews.book_id = books.id) AS reviews_count, (SELECT ROUND(AVG(reviews.rating), 1) FROM reviews where reviews.book_id = books.id) AS average_rating, (SELECT COUNT(*) FROM favorite_books WHERE favorite_books.book_id = books.id) AS favorite_books_count, (SELECT COUNT(*) FROM favorite_books WHERE favorite_books.book_id = books.id and favorite_books.user_id = #{current_user_id}) AS check_favorite")
                .where("name LIKE ?", "%#{search_books_keyword}%")
                .or(Book.where("author LIKE ?", "%#{search_books_keyword}%"))
                .or(Book.where("publisher LIKE ?", "%#{search_books_keyword}%"))
                .or(Book.where("subject LIKE ?", "%#{search_books_keyword}%"))
    books_with_images = books.map do |book|
      if book.image.attached?
        image_url = rails_blob_url(book.image)
      end
      book.as_json.merge(image: image_url)
    end
    books_count = books.length
    if books_with_images.present?
      render json: {
        books: books_with_images, include: [:reviews, :favorite_books],
        books_count: books_count
      }
    else
      render json: { message: "検索結果がありません", data: [] }
    end
  end

  def check_existence
    book = Book.find_by(id: params[:id])
    if book
      head :ok
    else
      head :not_fount
    end
  end

  def download_book_image
    url = params[:image_url]
    response = HTTParty.get(url)
    if response.code == 200
      send_data response.body, filename: 'downloaded-image.jpg', disposition: 'inline', type: response.headers['content-type']
    else
      render json: { error: 'Failed to download image.' }, status: :unprocessable_entity
    end
  end

  private

    def book_params
      params.require(:book).permit(:name, :author, :publisher, :subject, :image, :user_id, :description)
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
