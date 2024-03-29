module SharedActions::AttachImage
  extend ActiveSupport::Concern

  include SharedActions::DateTime


  # ↓配列の各要素に対してimageをアタッチするアクション一覧

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

  def attach_image_to_replies(replies)
    replies_with_images = replies.map do |reply|
      reply_data = reply.as_json

      if reply.image.attached?
        reply_data["image"] = rails_blob_url(reply.image)
      end

      if reply.user.image.attached?
        user_data = reply.user.as_json
        user_data["image"] = rails_blob_url(reply.user.image)
        reply_data["user"] = user_data
      else
        user_data = reply.user.as_json
        reply_data["user"] = user_data
      end

      question_data = reply.question.as_json
      reply_data["question"] = question_data

      reply_data["created_at"] = format_japanese_time(reply.created_at)

      reply_data
    end

    replies_with_images
  end


  def attach_image_to_subject_question_replies(subject_question_replies)
    subject_question_replies_with_images = subject_question_replies.map do |subject_question_reply|
      subject_question_reply_data = subject_question_reply.as_json

      if subject_question_reply.image.attached?
        subject_question_reply_data["image"] = rails_blob_url(subject_question_reply.image)
      end

      if subject_question_reply.user.image.attached?
        user_data = subject_question_reply.user.as_json
        user_data["image"] = rails_blob_url(subject_question_reply.user.image)
        subject_question_reply_data["user"] = user_data
      else
        user_data = subject_question_reply.user.as_json
        subject_question_reply_data["user"] = user_data
      end

      subject_question_data = subject_question_reply.subject_question.as_json
      subject_question_reply_data["subject_question"] = subject_question_data

      subject_question_reply_data["created_at"] = format_japanese_time(subject_question_reply.created_at)

      subject_question_reply_data
    end

    subject_question_replies_with_images
  end

  def attach_image_to_surveys(surveys)
    surveys_with_images = surveys.map do |survey|
      survey_data = survey.as_json

      if survey.user.image.attached?
        user_data = survey.user.as_json
        user_data["image"] = rails_blob_url(survey.user.image)
        survey_data["user"] = user_data
      else
        user_data = survey.user.as_json
        survey_data["user"] = user_data
      end

      survey_data["created_at"] = format_japanese_time(survey.created_at)

      survey_data
    end

    surveys_with_images
  end


  # 個別の要素に対してimageをアタッチするアクション一覧

  def attach_image_to_book(book)
    if book.image.attached?
      image_url = rails_blob_url(book.image)
    end
    book_json = book.as_json.merge(image: image_url)

    book_json
  end

  def attach_image_to_user(user)
    if user.image.attached?
      user_image_url = rails_blob_url(user.image)
    end
    user_json = user.as_json.merge(image: user_image_url)

    user_json
  end

  def attach_image_to_question(question)
    if question.image.attached?
      question_image_url = rails_blob_url(question.image)
    end
    question_json = question.as_json.merge(image: question_image_url)

    question_json
  end

  def attach_image_to_reply(reply)
    if reply.image.attached?
      image_url = rails_blob_url(reply.image)
    end
    reply_json = reply.as_json.merge(image: image_url)

    reply_json
  end

  def attach_image_to_survey(survey)
    if survey.image.attached?
      image_url = rails_blob_url(survey.image)
    end
    survey_json = survey.as_json.merge(image: image_url)

    survey_json
  end


end
