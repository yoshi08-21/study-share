class FavoriteQuestionsController < ApplicationController

  def create
    current_user = User.find_by(id: params[:current_user_id])
    return head :not_found unless current_user

    question = Question.find_by(id: params[:question_id])
    return head :not_found unless question

    return render json: { error: "自分の質問にはいいねできません" }, status: 422 if current_user.id == question.user_id

    favorite_question = current_user.favorite_questions.build(question_id: question.id)
    if favorite_question.save
      create_notification_favorite_question(current_user, question)
      render json: favorite_question, status: 200
    else
      render json: { error: favorite_question.errors.full_messages }, status: 422
    end
  end

  def destroy
    current_user = User.find_by(id: params[:current_user_id])
    return head :not_found unless current_user

    question = Question.find_by(id: params[:question_id])
    return head :not_found unless question

    favorite_question = FavoriteQuestion.find_by(user_id: current_user.id, question_id: question.id)
    return render json: { error: "いいねされていません" }, status: 404 unless favorite_question

    if favorite_question.destroy
      delete_notification_favorite_question(current_user, question)
      head :no_content
    else
      render json: { error: favorite_question.errors.full_messages }, status: 422
    end
  end


  private

    def create_notification_favorite_question(current_user, question)
      favorite_question_notification = Notification.find_by(action_user_id: current_user.id, question_id: question.id, action_type: "Favorite")
      if favorite_question_notification.blank?
        notification = current_user.sent_notifications.build(
          target_user_id: question.user_id,
          question_id: question.id,
          action_type: "Favorite",
          action_to: "Question",
        )
        notification.save if notification.valid?
      end
    end

    def delete_notification_favorite_question(current_user, question)
      favorite_question_notification = Notification.find_by(action_user_id: current_user.id, question_id: question.id, action_type: "Favorite")
      if favorite_question_notification
        favorite_question_notification.destroy
      end
    end

end
