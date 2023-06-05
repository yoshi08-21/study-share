class FavoriteSubjectQuestionRepliesController < ApplicationController

  def create
    current_user = User.find_by(id: params[:user_id])
    subject_question_reply = SubjectQuestionReply.find_by(id: params[:subject_question_reply_id])
    favorite_subject_question_reply = current_user.favorite_subject_question_replies.build(subject_question_reply_id: subject_question_reply.id)
    if !exist_favorite_subject_question_reply?(current_user, subject_question_reply)
      favorite_subject_question_reply.save
      create_notification_favorite_subject_question_reply(current_user, subject_question_reply)
      render json: favorite_subject_question_reply, status: 200
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end

  def destroy
    current_user = User.find_by(id: params[:user_id])
    subject_question_reply = SubjectQuestionReply.find_by(id: params[:subject_question_reply_id])
    favorite_subject_question_reply = FavoriteSubjectQuestionReply.find_by(user_id: current_user.id, subject_question_reply_id: subject_question_reply.id)
    if favorite_subject_question_reply.destroy
      delete_notification_favorite_subject_question_reply(current_user, subject_question_reply)
      render json: { status: :ok }
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end


  private

    def exist_favorite_subject_question_reply?(current_user, subject_question_reply)
      current_user.fav_subject_question_replies.include?(subject_question_reply)
    end

    def create_notification_favorite_subject_question_reply(current_user, subject_question_reply)
      favorite_subject_question_reply_notification = Notification.find_by(action_user_id: current_user.id, subject_question_reply_id: subject_question_reply.id, action_type: "Favorite")
      if favorite_subject_question_reply_notification.blank?
        notification = current_user.sent_notifications.build(
          target_user_id: subject_question_reply.user_id,
          subject_question_reply_id: subject_question_reply.id,
          action_type: "Favorite",
          action_to: "SubjectQuestionReply",
        )
        notification.save if notification.valid?
      end
    end

    def delete_notification_favorite_subject_question_reply(current_user, subject_question_reply)
      favorite_subject_question_reply_notification = Notification.find_by(action_user_id: current_user.id, subject_question_reply_id: subject_question_reply.id, action_type: "Favorite")
      if favorite_subject_question_reply_notification
        favorite_subject_question_reply_notification.destroy
      end
    end


end
