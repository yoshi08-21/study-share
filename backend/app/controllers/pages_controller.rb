class PagesController < ApplicationController

  def new_reviews
    reviews = Review.includes(:user, :book)
                      .includes(user: :image_attachment)
                      .order("created_at DESC")
                      .limit(10)

    reviews_with_images = reviews.map do |review|
      review_data = review.as_json
      if review.user.image.attached?
        user_data = review.user.as_json
        user_data["image"] = rails_blob_url(review.user.image)
        review_data["user"] = user_data
      else
        user_data = review.user.as_json
        review_data["user"] = user_data
      end

      book_data = review.book.as_json
      review_data["book"] = book_data

      review_data
    end
    if reviews_with_images
      render json: reviews_with_images
    else
      render json: reviews_with_images.errors
    end
  end

  def popular_books
    books = Book.includes(:reviews, :favorite_books)
                  .with_attached_image
                  .select("books.*, (SELECT COUNT(*) FROM reviews WHERE reviews.book_id = books.id) AS reviews_count, (SELECT ROUND(AVG(reviews.rating), 1) FROM reviews where reviews.book_id = books.id) AS average_rating, (SELECT COUNT(*) FROM favorite_books WHERE favorite_books.book_id = books.id) AS favorite_books_count")
                  .group("books.id")
                  .order("favorite_books_count DESC")
                  .limit(10)

    books_with_images = books.map do |book|
      if book.image.attached?
        image_url = rails_blob_url(book.image)
      end
      book.as_json.merge(image: image_url, average_rating: book.average_rating.to_f)
    end
    if books_with_images
      render json: books_with_images, include: "reviews"
    else
      render json: books.errors
    end
  end

  def get_same_university_books
    current_user = User.find_by(id: params[:current_user_id])
    if current_user && current_user.first_choice_school
      first_choice_school_books = Book.joins(favorite_books: :user)
                                        .with_attached_image
                                        .where("users.first_choice_school = ?",current_user.first_choice_school)
                                        .group(:book_id)
                                        .order("count(favorite_books.id) DESC")
                                        .limit(10)
                                        .includes([:reviews])

      first_choice_school_books_with_images = first_choice_school_books.map do |book|
        if book.image.attached?
          image_url = rails_blob_url(book.image)
        end
        book.as_json.merge(image: image_url)
      end
    end
    if current_user && current_user.second_choice_school
      second_choice_school_books = Book.joins(favorite_books: :user)
                                        .with_attached_image
                                        .where("users.first_choice_school = ?",current_user.second_choice_school)
                                        .group(:book_id)
                                        .order("count(favorite_books.id) DESC")
                                        .limit(50)
                                        .includes([:reviews])

      second_choice_school_books_with_images = second_choice_school_books.map do |book|
        if book.image.attached?
          image_url = rails_blob_url(book.image)
        end
        book.as_json.merge(image: image_url)
      end
    end
    if current_user && current_user.third_choice_school
      third_choice_school_books = Book.joins(favorite_books: :user)
                                        .with_attached_image
                                        .where("users.first_choice_school = ?",current_user.third_choice_school)
                                        .group(:book_id)
                                        .order("count(favorite_books.id) DESC")
                                        .limit(10)
                                        .includes([:reviews])

      third_choice_school_books_with_images = third_choice_school_books.map do |book|
        if book.image.attached?
          image_url = rails_blob_url(book.image)
        end
        book.as_json.merge(image: image_url)
      end
    end
    books = {
      first_choice_school_books: first_choice_school_books_with_images,
      second_choice_school_books: second_choice_school_books_with_images,
      third_choice_school_books: third_choice_school_books_with_images
    }
    books.compact!
    if books
      render json: books, include: "reviews"
    end
  end

end
