class SurveyAnswersController < ApplicationController

  def create
    current_user = User.find_by(id: params[:survey_answer][:user_id])
    return head :not_found unless current_user

    survey = Survey.includes(:user).find_by(id: params[:survey_answer][:survey_id])
    return head :not_found unless survey

    return render json: { error: "アンケートは締め切られています" }, status: 422 if is_survey_closed?(survey)

    return render json: { error: "自分のアンケートには回答できません" }, status: 422 if current_user.id == survey.user_id

    survey_answer = SurveyAnswer.find_by(user_id: current_user.id, survey_id: survey.id)
    return render json: { error: "すでに回答済みです" }, status: 422 if survey_answer

    survey_answer = current_user.survey_answers.build(survey_answer_params)
    if survey_answer.save
      create_notification_survey_answer(current_user, survey.user, survey)
      render json: survey_answer
    else
      render json: { error: survey_answer.errors.full_messages }, status: 422
    end
  end

  def change_survey_answer
    survey_answer = survey_answer_params
    selected_survey_answer = SurveyAnswer.find_by(user_id: survey_answer[:user_id], survey_id: survey_answer[:survey_id], selected_option: survey_answer[:selected_option])
    if selected_survey_answer
      selected_survey_answer.destroy
      delete_notification_survey_answer(survey_answer[:user_id], survey_answer[:survey_id])
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
    return head :not_found unless current_user

    survey = Survey.find_by(id: params[:survey_id])
    return head :not_found unless survey

    survey_answer = SurveyAnswer.find_by(user_id: current_user.id, survey_id: survey.id)
    if survey_answer
      render json: survey_answer, status: :ok
    else
      # エラーとして扱う必要がない場合は204が適切
      head :no_content
    end
  end

  def get_survey_answers
    survey_answers = SurveyAnswer.where(survey_id: params[:survey_id])
    if !survey_answers.empty?
      render json: survey_answers
    else
      render json: []
    end
  end


  private

    def survey_answer_params
      params.require(:survey_answer).permit(:selected_option, :user_id, :survey_id)
    end

    # アンケートが締め切られていたらtrueを返す
    def is_survey_closed?(survey)
      if survey.status == true
        return true
      else
        return false
      end
    end

    def create_notification_survey_answer(current_user, survey_author, survey)
      # アンケートの投稿者に通知を作成する
      # すでにアンケートへの回答の通知があった場合、一度削除してから再度作成する
      survey_answer_notification = Notification.find_by(action_user_id: current_user.id, survey_id: survey.id, action_type: "SurveyAnswer")
      if survey_answer_notification
        survey_answer_notification.destroy
      end
      survey_answer_notification = current_user.sent_notifications.build(
        target_user_id: survey_author.id,
        survey_id: survey.id,
        action_type: "SurveyAnswer",
        action_to: "SurveyAnswer"
      )
      survey_answer_notification.save if survey_answer_notification.valid?
    end

    def delete_notification_survey_answer(action_user_id, survey_id)
      survey_answer_notification = Notification.find_by(action_user_id: action_user_id, survey_id: survey_id, action_type: "SurveyAnswer")
      if survey_answer_notification
        survey_answer_notification.destroy
      end

    end

end
