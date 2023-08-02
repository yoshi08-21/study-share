class SurveyAnswersController < ApplicationController

  def create
    current_user = User.find_by(id: params[:survey_answer][:user_id])
    survey = Survey.find_by(id: params[:survey_answer][:survey_id])
    author = survey.user
    survey_answer = current_user.survey_answers.build(survey_answer_params)
    if !validate_authorship(current_user, author)
      if survey_answer.save
        render json: survey_answer
      else
        render json: { error: "エラーが発生しました" }, status: 400
      end
    end
  end

  private

    def survey_answer_params
      params.require(:survey_answer).permit(:selected_option, :user_id, :survey_id)
    end

end
