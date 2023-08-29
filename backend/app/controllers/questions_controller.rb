class QuestionsController < ApplicationController

  include ImageCompressionConcern
  include SharedActions::AttachImage
  include SharedActions::DateTime

  def index
    book = Book.find_by(id: params[:book_id])
    return head :not_found unless book

    questions = Question.includes(book: { image_attachment: :blob }, user: { image_attachment: :blob })
                          .select("questions.*, (SELECT COUNT(*) FROM replies WHERE replies.question_id = questions.id) AS replies_count, (SELECT COUNT(*) FROM favorite_questions WHERE favorite_questions.question_id = questions.id) AS favorite_questions_count")
                          .where(book_id: book.id)
    return render json: [] if questions.blank?

    questions_with_images = attach_image_to_questions(questions)
    render json: questions_with_images
  end

  def show
    current_user = User.find_by(id: params[:current_user_id])

    book = Book.with_attached_image
                .select("books.*, (SELECT COUNT(*) FROM reviews WHERE reviews.book_id = books.id) AS reviews_count, (SELECT ROUND(AVG(reviews.rating), 1) FROM reviews where reviews.book_id = books.id) AS average_rating, (SELECT COUNT(*) FROM favorite_books WHERE favorite_books.book_id = books.id) AS favorite_books_count, (SELECT COUNT(*) FROM questions WHERE questions.book_id = books.id) AS questions_count")
                .find_by(id: params[:book_id])
    return head :not_found unless book
    book_json = attach_image_to_book(book)

    question = Question.includes(book: { image_attachment: :blob }, user: { image_attachment: :blob })
                        .select("questions.*, (SELECT COUNT(*) FROM replies WHERE replies.question_id = questions.id) AS replies_count, (SELECT COUNT(*) FROM favorite_questions WHERE favorite_questions.question_id = questions.id) AS favorite_questions_count")
                        .find_by(id: params[:id])
    return head :not_found unless question
    question_json = attach_image_to_question(question)
    question_json["created_at"] = format_japanese_time(question.created_at)

    question_user = question.user
    question_user_json = attach_image_to_user(question_user)

    if current_user && !exist_question_browsing_history?(current_user, question)
      save_question_browsing_history(current_user, question)
    end

    render json: {
      book: book_json,
      question: question_json,
      question_user: question_user_json
    }
  end

  def create
    current_user = User.find_by(id: params[:current_user_id])
    return head :not_found unless current_user

    book = Book.find_by(id: params[:question][:book_id])
    return head :not_found unless book

    question = current_user.questions.build(question_params)
    question.book_id = book.id
    if question.save
      render json: question, status: 200
    else
      render json: { errors: question.errors.full_messages }, status: 422
    end
  end

  def update
    current_user = User.find_by(id: params[:current_user_id])
    return head :not_found unless current_user

    question = Question.find_by(id: params[:id])
    return head :not_found unless question

    author = question.user
    return render json: { error: "権限がありません" }, status: 422 unless validate_authorship(current_user, author)

    if question.update(question_params)
      image_url = question.image.attached? ? rails_blob_url(question.image) : nil
      render json: { question: question, image_url: image_url }, status: 200
    else
      render json: { errors: question.errors.full_messages }, status: 422
    end
  end

  def destroy
    current_user = User.find_by(id: params[:current_user_id])
    return head :not_found unless current_user

    question = Question.find_by(id: params[:id])
    return head :not_found unless question

    author = question.user
    return render json: { error: "権限がありません" }, status: 422 unless validate_authorship(current_user, author)

    if question.destroy
      head :no_content
    else
      render json: { errors: question.errors.full_messages }, status: 422
    end
  end

  def is_favorite
    current_user = User.find_by(id: params[:current_user_id])
    return head :not_found unless current_user

    question = Question.find_by(id: params[:question_id])
    return head :not_found unless question

    favorite_question = FavoriteQuestion.find_by(user_id: current_user.id, question_id: question.id) if current_user
    if favorite_question
      render json: { is_favorite: true, favorite_question_id: favorite_question.id }
    else
      render json: false
    end
  end

  def all_questions
    questions = Question.includes(book: { image_attachment: :blob }, user: { image_attachment: :blob })
                          .select("questions.*, (SELECT COUNT(*) FROM replies WHERE replies.question_id = questions.id) AS replies_count, (SELECT COUNT(*) FROM favorite_questions WHERE favorite_questions.question_id = questions.id) AS favorite_questions_count")
    return render json: [] if questions.blank?

    questions_with_images = attach_image_to_questions(questions)
    render json: questions_with_images
  end

  def search_questions
    search_questions_keyword = params[:searchQuestionsKeyword]
    questions = Question.includes(:user, :book)
                        .select("questions.*, (SELECT COUNT(*) FROM replies WHERE replies.question_id = questions.id) AS replies_count, (SELECT COUNT(*) FROM favorite_questions WHERE favorite_questions.question_id = questions.id) AS favorite_questions_count")
                        .where("title LIKE ?", "%#{search_questions_keyword}%")
                        .or(Question.where("content LIKE ?", "%#{search_questions_keyword}%"))
                        .or(Question.where("subject LIKE ?", "%#{search_questions_keyword}%"))

    questions_count = questions.length
    questions_with_images = attach_image_to_questions(questions)

    render json: {
      questions: questions_with_images,
      questions_count: questions_count
    }
  end

  # checkResourceExistence.jsから呼び出し
  def check_existence
    book = Book.find_by(id: params[:book_id])
    return head :not_found unless book

    question = Question.find_by(id: params[:id])
    return head :not_found unless question

    head :ok
  end


  private

    def question_params
      params.require(:question).permit(:title, :content, :subject, :user_id, :book_id, :image)
    end

    def exist_question_browsing_history?(current_user, question)
      current_user.watched_questions.include?(question)
    end

    def save_question_browsing_history(current_user, question)
      question_browsing_histories = BrowsingHistory.where(user_id: current_user.id).where.not(question_id: nil)
      max_browsing_histories = 10
      if question_browsing_histories.count >= max_browsing_histories
        question_browsing_histories.first.destroy
        current_user.browsing_histories.create(question_id: question.id)
      else
        current_user.browsing_histories.create(question_id: question.id)
      end
    end

end
