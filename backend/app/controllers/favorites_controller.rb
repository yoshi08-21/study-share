class FavoritesController < ApplicationController

  include SharedActions::AttachImage

  def index
    current_user = User.find_by(id: params[:user_id])
    favorite_books = current_user.fav_books.with_attached_image.select("books.*, (SELECT COUNT(*) FROM reviews WHERE reviews.book_id = books.id) AS reviews_count, (SELECT ROUND(AVG(reviews.rating), 1) FROM reviews where reviews.book_id = books.id) AS average_rating, (SELECT COUNT(*) FROM favorite_books WHERE favorite_books.book_id = books.id) AS favorite_books_count, (SELECT COUNT(*) FROM favorite_books WHERE favorite_books.book_id = books.id and favorite_books.user_id = #{current_user.id}) AS check_favorite")
    favorite_books_with_images = attach_image_to_books(favorite_books)

    favorite_reviews = current_user.fav_reviews.includes(book: { image_attachment: :blob }, user: { image_attachment: :blob }).select("reviews.*, (SELECT COUNT(*) FROM favorite_reviews WHERE favorite_reviews.review_id = reviews.id) AS favorite_reviews_count")
    favorite_reviews_with_images = attach_image_to_reviews(favorite_reviews)

    favorite_questions = current_user.fav_questions.with_attached_image.includes(book: { image_attachment: :blob }, user: { image_attachment: :blob }).select("questions.*, (SELECT COUNT(*) FROM replies WHERE replies.question_id = questions.id) AS replies_count, (SELECT COUNT(*) FROM favorite_questions WHERE favorite_questions.question_id = questions.id) AS favorite_questions_count")
    favorite_questions_with_images = attach_image_to_questions(favorite_questions)

    favorite_replies = current_user.fav_replies.with_attached_image.includes(:question, user: { image_attachment: :blob }).select("replies.*, (SELECT COUNT(*) FROM favorite_replies WHERE favorite_replies.reply_id = replies.id) AS favorite_replies_count")
    favorite_replies_with_images = attach_image_to_replies(favorite_replies)


    favorite_subject_questions = current_user.fav_subject_questions.with_attached_image.includes(user: { image_attachment: :blob }).select("subject_questions.*, (SELECT COUNT(*) FROM subject_question_replies WHERE subject_question_replies.subject_question_id = subject_questions.id) AS subject_question_replies_count, (SELECT COUNT(*) FROM favorite_subject_questions WHERE favorite_subject_questions.subject_question_id = subject_questions.id) AS favorite_subject_questions_count")
    favorite_subject_questions_with_images = attach_image_to_subject_questions(favorite_subject_questions)

    favorite_subject_question_replies = current_user.fav_subject_question_replies.with_attached_image.includes(:subject_question, user: { image_attachment: :blob }).select("subject_question_replies.*, (SELECT COUNT(*) FROM favorite_subject_question_replies WHERE favorite_subject_question_replies.subject_question_reply_id = subject_question_replies.id) AS favorite_subject_question_replies_count")
    favorite_subject_question_replies_with_images = attach_image_to_subject_question_replies(favorite_subject_question_replies)

    favorite_surveys = current_user.fav_surveys.with_attached_image.includes(user: { image_attachment: :blob }).select("surveys.*, (SELECT COUNT(*) FROM survey_answers WHERE survey_answers.survey_id = surveys.id) AS survey_answers_count, (SELECT COUNT(*) FROM favorite_surveys WHERE favorite_surveys.survey_id = surveys.id) AS favorite_surveys_count")
    favorite_surveys_with_images = attach_image_to_surveys(favorite_surveys)

    if current_user
      render json: {
        favorite_books: favorite_books_with_images,
        favorite_reviews: favorite_reviews_with_images,
        favorite_questions: favorite_questions_with_images,
        favorite_replies: favorite_replies_with_images,
        favorite_subject_questions: favorite_subject_questions_with_images,
        favorite_subject_question_replies: favorite_subject_question_replies_with_images,
        favorite_surveys: favorite_surveys_with_images
      },
      status: 200
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end


  private



end
