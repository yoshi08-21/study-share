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
    book = Book.find_by(id: params[:book_id])
    question = Question.includes(:user).find_by(id: params[:id])
    if question
      render json: {
        book: book,
        question: question.as_json(include: :user)
      }
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
    question = Question.find_by(id: params[:id])
    current_user = User.find_by(id: params[:current_user_id])
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
    question = Question.find_by(id: params[:id])
    current_user = User.find_by(id: params[:current_user_id])
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




  private

    def question_params
      params.require(:question).permit(:title, :content, :subject, :user_id, :book_id)
    end

end
