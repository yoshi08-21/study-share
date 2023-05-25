class FavoriteSubjectQuestionsController < ApplicationController

  def create
    current_user = User.find_by(id: params[:user_id])
    subject_question = SubjectQuestion.find_by(id: params[:subject_question_id])
    favorite_subject_question = current_user.favorite_subject_questions.build(subject_question_id: subject_question.id)
    if !exist_favorite_subject_question?(current_user, subject_question)
      favorite_subject_question.save
      render json: favorite_subject_question, status: 200
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end

  def destroy
    current_user = User.find_by(id: params[:user_id])
    subject_question = SubjectQuestion.find_by(id: params[:subject_question_id])
    favorite_subject_question = FavoriteSubjectQuestion.find_by(user_id: current_user.id, subject_question_id: subject_question.id)
    if favorite_subject_question.destroy
      render json: { status: :ok }
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end


  private

    def exist_favorite_subject_question?(current_user, subject_question)
      current_user.fav_subject_questions.include?(subject_question)
    end



end
