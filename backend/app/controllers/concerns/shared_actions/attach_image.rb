module SharedActions::AttachImage
  extend ActiveSupport::Concern


  def attach_image_to_books(books)
    books_with_images = books.map do |book|
      if book.image.attached?
        image_url = rails_blob_url(book.image)
      end
      book.as_json.merge(image: image_url)
    end

      books_with_images
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

      question_data
    end

    questions_with_images
  end

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

      question_data
    end

    subject_questions_with_images
  end




end
