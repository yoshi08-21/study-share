class FavoriteSurveysController < ApplicationController

  def create
    current_user = User.find_by(id: params[:user_id])
    return head :not_found unless current_user

    survey = Survey.find_by(id: params[:survey_id])
    return head :not_found unless survey

    return render json: { error: "自分のアンケートにはいいねできません" }, status: 422 if current_user.id == survey.user_id

    favorite_survey = current_user.favorite_surveys.build(survey_id: survey.id)
    if favorite_survey.save
      create_notification_favorite_survey(current_user, survey)
      render json: favorite_survey, status: 200
    else
      render json: { error: favorite_survey.errors.full_messages }, status: 422
    end
  end

  def destroy
    current_user = User.find_by(id: params[:user_id])
    return head :not_found unless current_user

    survey = Survey.find_by(id: params[:survey_id])
    return head :not_found unless survey

    favorite_survey = FavoriteSurvey.find_by(user_id: current_user.id, survey_id: survey.id)
    return render json: { error: "いいねされていません" }, status: 404 unless favorite_survey

    if favorite_survey.destroy
      delete_notification_favorite_survey(current_user, survey)
      head :no_content
    else
      render json: { error: favorite_survey.errors.full_messages }, status: 422
    end
  end

  private

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
