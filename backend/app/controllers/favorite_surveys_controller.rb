class FavoriteSurveysController < ApplicationController

  def create
    current_user = User.find_by(id: params[:user_id])
    survey = Survey.find_by(id: params[:survey_id])
    favorite_survey = current_user.favorite_surveys.build(survey_id: survey.id)
    if !exist_favorite_survey?(current_user, survey)
      favorite_survey.save
      create_notification_favorite_survey(current_user, survey)
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
      delete_notification_favorite_survey(current_user, survey)
      render json: { status: :ok }
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end

  private

  def exist_favorite_survey?(current_user, survey)
    current_user.fav_surveys.include?(survey)
  end

  def create_notification_favorite_survey(current_user, survey)
    favorite_survey_notification = Notification.find_by(action_user_id: current_user.id, survey_id: survey.id, action_type: "Favorite")
    if favorite_survey_notification.blank?
      notification = current_user.sent_notifications.build(
        target_user_id: survey.user_id,
        survey_id: survey.id,
        action_type: "Favorite",
        action_to: "Survey",
      )
      notification.save if notification.valid?
    end
  end

  def delete_notification_favorite_survey(current_user, survey)
    favorite_survey_notification = Notification.find_by(action_user_id: current_user.id, survey_id: survey.id, action_type: "Favorite")
    if favorite_survey_notification
      favorite_survey_notification.destroy
    end
  end



end
