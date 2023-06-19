class BrowsingHistoriesController < ApplicationController

  def index
    current_user = User.find_by(id: params[:current_user_id])
    book_browsing_histories = current_user.watched_books.select("books.*, (SELECT COUNT(*) FROM reviews WHERE reviews.book_id = books.id) AS reviews_count, (SELECT ROUND(AVG(reviews.rating), 1) FROM reviews where reviews.book_id = books.id) AS average_rating, (SELECT COUNT(*) FROM favorite_books WHERE favorite_books.book_id = books.id) AS favorite_books_count, (SELECT COUNT(*) FROM favorite_books WHERE favorite_books.book_id = books.id and favorite_books.user_id = #{current_user.id}) AS check_favorite")
    review_browsing_histories = current_user.watched_reviews.includes(:user, :book)
    question_browsing_histories = current_user.watched_questions.includes(:user, :book).select("questions.*, (SELECT COUNT(*) FROM replies WHERE replies.question_id = questions.id) AS replies_count, (SELECT COUNT(*) FROM favorite_questions WHERE favorite_questions.question_id = questions.id) AS favorite_questions_count")
    subject_question_browsing_histories = current_user.watched_subject_questions.includes(:user).select("subject_questions.*, (SELECT COUNT(*) FROM subject_question_replies WHERE subject_question_replies.subject_question_id = subject_questions.id) AS subject_question_replies_count, (SELECT COUNT(*) FROM favorite_subject_questions WHERE favorite_subject_questions.subject_question_id = subject_questions.id) AS favorite_subject_questions_count")
    reply_browsing_histories = current_user.watched_replies.includes(:user, :question)
    subject_question_reply_browsing_histories = current_user.watched_subject_question_replies.includes(:user, :subject_question)

    if current_user
      render json: {
        book_browsing_histories: book_browsing_histories,
        review_browsing_histories: review_browsing_histories.as_json(include: [:user, :book]),
        question_browsing_histories: question_browsing_histories.as_json(include: [:user, :book]),
        subject_question_browsing_histories: subject_question_browsing_histories.as_json(include: :user),
        reply_browsing_histories: reply_browsing_histories.as_json(include: [:user, :question]),
        subject_question_reply_browsing_histories:subject_question_reply_browsing_histories.as_json(include: [:user, :subject_question]),
      }
    else
      render json: { error: "エラーが発生しました" }
    end
  end

end
