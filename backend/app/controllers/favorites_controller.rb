class FavoritesController < ApplicationController

  def index
    current_user = User.find_by(id: params[:user_id])
    favorite_books = current_user.fav_books.select("books.*, (SELECT COUNT(*) FROM reviews WHERE reviews.book_id = books.id) AS reviews_count, (SELECT ROUND(AVG(reviews.rating), 1) FROM reviews where reviews.book_id = books.id) AS average_rating, (SELECT COUNT(*) FROM favorite_books WHERE favorite_books.book_id = books.id) AS favorite_books_count")
    favorite_reviews = current_user.fav_reviews.includes(:user, :book)
    favorite_questions = current_user.fav_questions.includes(:user, :book).select("questions.*, (SELECT COUNT(*) FROM replies WHERE replies.question_id = questions.id) AS replies_count, (SELECT COUNT(*) FROM favorite_questions WHERE favorite_questions.question_id = questions.id) AS favorite_questions_count")
    favorite_replies = current_user.fav_replies.includes(:user, :question)
    favorite_subject_questions = current_user.fav_subject_questions.includes(:user).select("subject_questions.*, (SELECT COUNT(*) FROM subject_question_replies WHERE subject_question_replies.subject_question_id = subject_questions.id) AS subject_question_replies_count, (SELECT COUNT(*) FROM favorite_subject_questions WHERE favorite_subject_questions.subject_question_id = subject_questions.id) AS favorite_subject_questions_count")
    favorite_subject_question_replies = current_user.fav_subject_question_replies.includes(:user, :subject_question)
    if current_user
      render json: {
        favorite_books: favorite_books,
        favorite_reviews: favorite_reviews.as_json(include: [:user, :book]),
        favorite_questions: favorite_questions.as_json(include: [:user, :book]),
        favorite_replies: favorite_replies.as_json(include: [:user, :question]),
        favorite_subject_questions: favorite_subject_questions.as_json(include: :user),
        favorite_subject_question_replies: favorite_subject_question_replies.as_json(include: [:user, :subject_question])
      },
      status: 200
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end

end
