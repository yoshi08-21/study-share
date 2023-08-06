class SurveyAnswersController < ApplicationController

  def create
    current_user = User.find_by(id: params[:survey_answer][:user_id])
    survey = Survey.find_by(id: params[:survey_answer][:survey_id])
    survey_answer = current_user.survey_answers.build(survey_answer_params)
    if !exist_survey_answer?(current_user, survey)
      if survey_answer.save
        render json: survey_answer
      else
        render json: { error: "エラーが発生しました" }, status: 400
      end
    else
      render json: { error: "すでに回答済みです" }, status: 400
    end
  end

  def change_survey_answer
    survey_answer = survey_answer_params
    selected_survey_answer = SurveyAnswer.find_by(user_id: survey_answer[:user_id], survey_id: survey_answer[:survey_id], selected_option: survey_answer[:selected_option])
    if selected_survey_answer
      selected_survey_answer.destroy
      head :no_content
    else
      exist_survey_answer = SurveyAnswer.find_by(user_id: survey_answer[:user_id], survey_id: survey_answer[:survey_id])
      exist_survey_answer.selected_option = survey_answer[:selected_option]
      exist_survey_answer.save
      render json: exist_survey_answer
    end
  end

  def check_current_user_answer
    current_user = User.find_by(id: params[:user_id])
    survey = Survey.find_by(id: params[:survey_id])
    survey_answer = SurveyAnswer.find_by(user_id: current_user.id, survey_id: survey.id)
    if survey_answer
      render json: survey_answer, status: :ok
    else
      head :no_content
    end
  end

  def get_survey_answers
    survey_answers = SurveyAnswer.where(survey_id: params[:survey_id])
    if survey_answers
      render json: survey_answers
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end


  private

    def survey_answer_params
      params.require(:survey_answer).permit(:selected_option, :user_id, :survey_id)
    end

    def exist_survey_answer?(current_user, survey)
      survey_answer = SurveyAnswer.find_by(user_id: current_user.id, survey_id: survey.id)
      #  ifの代わりに !!answerとも書ける
      if survey_answer
        return true
      else
        return false
      end
    end

    def check_survey_answer(current_user, survey, survey_answer)
      selected_survey_answer = SurveyAnswer.find_by(user_id: current_user.id, survey_id: survey.id, survey_answer: survey_answer.id)
      if selected_survey_answer
        return true
      else
        return false
      end
    end

end
