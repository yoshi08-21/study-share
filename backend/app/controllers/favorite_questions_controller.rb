class FavoriteQuestionsController < ApplicationController

  def create
    current_user = User.find_by(id: params[:user_id])
    question = Question.find_by(id: params[:question_id])
    favorite_question = current_user.favorite_questions.build(question_id: question.id)
    if !exist_favorite_question?(current_user, question)
      favorite_question.save
      create_notification_favorite_question(current_user, question)
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
      delete_notification_favorite_question(current_user, question)
      render json: { status: :ok }
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end


  private

    def exist_favorite_question?(current_user, question)
      current_user.fav_questions.include?(question)
    end

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
