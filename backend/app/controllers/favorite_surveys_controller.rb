class FavoriteSurveysController < ApplicationController

  def create
    current_user = User.find_by(id: params[:user_id])
    survey = Survey.find_by(id: params[:survey_id])
    favorite_survey = current_user.favorite_surveys.build(survey_id: survey.id)
    if favorite_survey
      favorite_survey.save
      render json: favorite_survey, status: 200
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end

  def destroy
    current_user = User.find_by(id: params[:user_id])
    survey = Survey.find_by(id: params[:survey_id])
    favorite_survey = FavoriteSurvey.find_by(user_id: current_user.id, survey_id: survey.id)
    if favorite_survey.destroy
      render json: { status: :ok }
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end
end
