module SharedActions::AttachImage
  extend ActiveSupport::Concern

  include SharedActions::DateTime


  def attach_image_to_books(books)
    books_with_images = books.map do |book|
      if book.image.attached?
        image_url = rails_blob_url(book.image)
      end
      book.as_json.merge(image: image_url)
    end

      books_with_images
  end

  def attach_image_to_reviews (reviews)
    reviews_with_images = reviews.map do |review|
      review_data = review.as_json

      if review.book.image.attached?
        book_data = review.book.as_json
        book_data["image"] = rails_blob_url(review.book.image)
        review_data["book"] = book_data
      else
        book_data = review.book.as_json
        review_data["book"] = book_data
      end

      if review.user.image.attached?
        user_data = review.user.as_json
        user_data["image"] = rails_blob_url(review.user.image)
        review_data["user"] = user_data
      else
        user_data = review.user.as_json
        review_data["user"] = user_data
      end

      review_data["created_at"] = format_japanese_time(review.created_at)

      review_data
    end

    reviews_with_images
  end

  def attach_image_to_questions(questions)
    questions_with_images = questions.map do |question|
      question_data = question.as_json

      if question.book.image.attached?
        book_data = question.book.as_json
        book_data["image"] = rails_blob_url(question.book.image)
        question_data["book"] = book_data
      else
        book_data = question.book.as_json
        question_data["book"] = book_data
      end

      if question.user.image.attached?
        user_data = question.user.as_json
        user_data["image"] = rails_blob_url(question.user.image)
        question_data["user"] = user_data
      else
        user_data = question.user.as_json
        question_data["user"] = user_data
      end

      question_data["created_at"] = format_japanese_time(question.created_at)

      question_data
    end

    questions_with_images
  end

  # Bookが必要ない点で↑と異なる
  def attach_image_to_subject_questions(subject_questions)
    subject_questions_with_images = subject_questions.map do |question|
      question_data = question.as_json

      if question.user.image.attached?
        user_data = question.user.as_json
        user_data["image"] = rails_blob_url(question.user.image)
        question_data["user"] = user_data
      else
        user_data = question.user.as_json
        question_data["user"] = user_data
      end

      question_data["created_at"] = format_japanese_time(question.created_at)

      question_data
    end

    subject_questions_with_images
  end




end
