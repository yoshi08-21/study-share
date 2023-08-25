class FavoriteSubjectQuestionsController < ApplicationController

  def create
    current_user = User.find_by(id: params[:user_id])
    return head :not_found unless current_user

    subject_question = SubjectQuestion.find_by(id: params[:subject_question_id])
    return head :not_found unless subject_question

    return render json: { error: "自分の質問にはいいねできません" }, status: 422 if current_user.id == subject_question.user_id

    favorite_subject_question = current_user.favorite_subject_questions.build(subject_question_id: subject_question.id)
    if favorite_subject_question.save
      create_notification_favorite_subject_question(current_user, subject_question)
      render json: favorite_subject_question, status: 200
    else
      render json: { error: favorite_subject_question.errors.full_messages }, status: 422
    end
  end

  def destroy
    current_user = User.find_by(id: params[:user_id])
    return head :not_found unless current_user

    subject_question = SubjectQuestion.find_by(id: params[:subject_question_id])
    return head :not_found unless subject_question

    favorite_subject_question = FavoriteSubjectQuestion.find_by(user_id: current_user.id, subject_question_id: subject_question.id)
    return render json: { error: "いいねされていません" }, status: 404 unless favorite_subject_question


    if favorite_subject_question.destroy
      delete_notification_favorite_subject_question(current_user, subject_question)
      head :no_content
    else
      render json: { error: favorite_subject_question.errors.full_messages }, status: 422
    end
  end


  private

    def create_notification_favorite_subject_question(current_user, subject_question)
      favorite_subject_question_notification = Notification.find_by(action_user_id: current_user.id, subject_question_id: subject_question.id, action_type: "Favorite")
      if favorite_subject_question_notification.blank?
        notification = current_user.sent_notifications.build(
          target_user_id: subject_question.user_id,
          subject_question_id: subject_question.id,
          action_type: "Favorite",
          action_to: "SubjectQuestion",
        )
        notification.save if notification.valid?
      end
    end

    def delete_notification_favorite_subject_question(current_user, subject_question)
      favorite_subject_question_notification = Notification.find_by(action_user_id: current_user.id, subject_question_id: subject_question.id, action_type: "Favorite")
      if favorite_subject_question_notification
        favorite_subject_question_notification.destroy
      end
    end



end
