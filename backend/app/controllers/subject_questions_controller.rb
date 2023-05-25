class SubjectQuestionsController < ApplicationController

  def index
    subject_questions = SubjectQuestion.includes(:user).all
    if subject_questions
      render json: subject_questions, include: "user"
    else
      render json: subject_questions.errors
    end
  end


  def show
    subject_question = SubjectQuestion.includes(:user).find_by(id: params[:id])
    # favorite_questions = FavoriteQuestion.where(question_id: question.id)
    # favorite_questions_count = favorite_questions.count
    if subject_question
      render json: {
        subject_question: subject_question.as_json(include: :user),
        # favorite_subject_questions_count: favorite_subject_questions_count
      }
    else
      render json: subject_question.errors
    end
  end


  def create
    current_user = User.find_by(id: params[:user_id])
    subject_question = current_user.subject_questions.build(subject_question_params)
    if subject_question.save
      render json: subject_question, status: 200
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end

  def update
    current_user = User.find_by(id: params[:current_user_id])
    subject_question = SubjectQuestion.find_by(id: params[:id])
    author = subject_question.user
    if validate_authorship(current_user, author)
      if subject_question.update(subject_question_params)
        render json: subject_question, status: 200
      else
        render json: { error: "エラーが発生しました" }, status: 400
      end
    else
      render json: { error: "権限がありません" }, status: 400
    end
  end

  def destroy
    current_user = User.find_by(id: params[:current_user_id])
    subject_question = SubjectQuestion.find_by(id: params[:id])
    author = subject_question.user
    if validate_authorship(current_user, author)
      if subject_question.destroy
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

    def subject_question_params
      params.require(:subject_question).permit(:title, :content, :subject, :user_id)
    end




end
