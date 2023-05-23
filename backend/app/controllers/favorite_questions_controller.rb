class FavoriteQuestionsController < ApplicationController

  def create
    current_user = User.find_by(id: params[:user_id])
    question = Question.find_by(id: params[:question_id])
    favorite_question = current_user.favorite_questions.build(question_id: question.id)
    if !exist_favorite_question?(current_user, question)
      favorite_question.save
      render json: favorite_question, status: 200
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end

  def destroy
    current_user = User.find_by(id: params[:user_id])
    question = Question.find_by(id: params[:question_id])
    favorite_question = FavoriteQuestion.find_by(user_id: current_user.id, question_id: question.id)
    if favorite_question.destroy
      render json: { status: :ok }
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end


  private

    def exist_favorite_question?(current_user, question)
      current_user.fav_questions.include?(question)
    end



end
