class QuestionsController < ApplicationController

  def index
    book = Book.find_by(id: params[:book_id])
    questions = book.questions.includes(:user)
    if questions
      render json: questions, include: "user"
    else
      render json: questinos.errors
    end
  end

  def show
    current_user = User.find_by(id: params[:current_user_id])
    book = Book.find_by(id: params[:book_id])
    question = Question.includes(:user).find_by(id: params[:id])
    favorite_questions = FavoriteQuestion.where(question_id: question.id)
    favorite_questions_count = favorite_questions.count
    if question
      render json: {
        book: book,
        question: question.as_json(include: :user),
        favorite_questions_count: favorite_questions_count
      }
      if current_user && !exist_question_browsing_history?(current_user, question)
        save_question_browsing_history(current_user, question)
      end
    else
      render json: question.errors
    end
  end

  def create
    current_user = User.find_by(id: params[:user_id])
    book = Book.find_by(id: params[:book_id])
    question = current_user.questions.build(question_params)
    question.book_id = book.id
    if question.save
      render json: question, status: 200
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end

  def update
    current_user = User.find_by(id: params[:current_user_id])
    question = Question.find_by(id: params[:id])
    author = question.user
    if validate_authorship(current_user, author)
      if question.update(question_params)
        render json: question, status: 200
      else
        render json: { error: "エラーが発生しました" }, status: 400
      end
    else
      render json: { error: "権限がありません" }, status: 400
    end
  end

  def destroy
    current_user = User.find_by(id: params[:current_user_id])
    question = Question.find_by(id: params[:id])
    author = question.user
    if validate_authorship(current_user, author)
      if question.destroy
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
    question = Question.find_by(id: params[:question_id])
    favorite_question = FavoriteQuestion.find_by(user_id: current_user.id, question_id: question.id)
    if favorite_question
      render json: { is_favorite: true, favorite_question_id: favorite_question.id }
    else
      render json: false
    end
  end

  def all_questions
    questions = Question.includes(:user, :book).all
    if questions
      render json: questions, include: [:user, :book]
    else
      render jso: questions.errors
    end
  end


  private

    def question_params
      params.require(:question).permit(:title, :content, :subject, :user_id, :book_id)
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
