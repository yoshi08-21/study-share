class BrowsingHistoriesController < ApplicationController

  include SharedActions::AttachImage

  def index
    current_user = User.find_by(id: params[:current_user_id])
    book_browsing_histories = current_user.watched_books.with_attached_image.select("books.*, (SELECT COUNT(*) FROM reviews WHERE reviews.book_id = books.id) AS reviews_count, (SELECT ROUND(AVG(reviews.rating), 1) FROM reviews where reviews.book_id = books.id) AS average_rating, (SELECT COUNT(*) FROM favorite_books WHERE favorite_books.book_id = books.id) AS favorite_books_count, (SELECT COUNT(*) FROM favorite_books WHERE favorite_books.book_id = books.id and favorite_books.user_id = #{current_user.id}) AS check_favorite")
    book_browsing_histories_with_images = attach_image_to_books(book_browsing_histories)

    review_browsing_histories = current_user.watched_reviews.includes(book: { image_attachment: :blob }, user: { image_attachment: :blob }).select("reviews.*, (SELECT COUNT(*) FROM favorite_reviews WHERE favorite_reviews.review_id = reviews.id) AS favorite_reviews_count")
    review_browsing_histories_with_images = attach_image_to_reviews(review_browsing_histories)

    question_browsing_histories = current_user.watched_questions.includes(book: { image_attachment: :blob }, user: { image_attachment: :blob }).select("questions.*, (SELECT COUNT(*) FROM replies WHERE replies.question_id = questions.id) AS replies_count, (SELECT COUNT(*) FROM favorite_questions WHERE favorite_questions.question_id = questions.id) AS favorite_questions_count")
    question_browsing_histories_with_images  = attach_image_to_questions(question_browsing_histories)

    subject_question_browsing_histories = current_user.watched_subject_questions.includes(user: { image_attachment: :blob }).select("subject_questions.*, (SELECT COUNT(*) FROM subject_question_replies WHERE subject_question_replies.subject_question_id = subject_questions.id) AS subject_question_replies_count, (SELECT COUNT(*) FROM favorite_subject_questions WHERE favorite_subject_questions.subject_question_id = subject_questions.id) AS favorite_subject_questions_count")
    subject_question_browsing_histories_with_images = attach_image_to_subject_questions(subject_question_browsing_histories)


    reply_browsing_histories = current_user.watched_replies.includes(:user, :question)
    subject_question_reply_browsing_histories = current_user.watched_subject_question_replies.includes(:user, :subject_question)
    survey_browsing_histories = current_user.watched_surveys.includes(:user).select("surveys.*, (SELECT COUNT(*) FROM survey_answers WHERE survey_answers.survey_id = surveys.id) AS survey_answers_count, (SELECT COUNT(*) FROM favorite_surveys WHERE favorite_surveys.survey_id = surveys.id) AS favorite_surveys_count")

    if current_user
      render json: {
        book_browsing_histories: book_browsing_histories_with_images,
        review_browsing_histories: review_browsing_histories_with_images,
        question_browsing_histories: question_browsing_histories_with_images,
        subject_question_browsing_histories: subject_question_browsing_histories_with_images,
        reply_browsing_histories: reply_browsing_histories.as_json(include: [:user, :question]),
        subject_question_reply_browsing_histories: subject_question_reply_browsing_histories.as_json(include: [:user, :subject_question]),
        survey_browsing_histories: survey_browsing_histories.as_json(include: :user)
      }
    else
      render json: { error: "エラーが発生しました" }
    end
  end

end
