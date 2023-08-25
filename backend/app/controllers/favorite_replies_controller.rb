class FavoriteRepliesController < ApplicationController

  def create
    current_user = User.find_by(id: params[:user_id])
    return head :not_found unless current_user

    reply = Reply.find_by(id: params[:reply_id])
    return head :not_found unless reply

    return render json: { error: "自分の返信にはいいねできません" }, status: 422 if current_user.id == reply.user_id

    favorite_reply = current_user.favorite_replies.build(reply_id: reply.id)
    if favorite_reply.save
      create_notification_favorite_reply(current_user, reply)
      render json: favorite_reply, status: 200
    else
      render json: { error: favorite_reply.errors.full_messages }, status: 422
    end
  end

  def destroy
    current_user = User.find_by(id: params[:user_id])
    return head :not_found unless current_user

    reply = Reply.find_by(id: params[:reply_id])
    return head :not_found unless reply

    favorite_reply = FavoriteReply.find_by(user_id: current_user.id, reply_id: reply.id)
    return render json: { error: "いいねされていません" }, status: 404 unless favorite_reply

    if favorite_reply.destroy
      delete_notification_favorite_reply(current_user, reply)
      head :no_content
    else
      render json: { error: favorite_reply.errors.full_messages }, status: 422
    end
  end


  private

    def create_notification_favorite_reply(current_user, reply)
      favorite_reply_notification = Notification.find_by(action_user_id: current_user.id, reply_id: reply.id, action_type: "Favorite")
      if favorite_reply_notification.blank?
        notification = current_user.sent_notifications.build(
          target_user_id: reply.user_id,
          reply_id: reply.id,
          action_type: "Favorite",
          action_to: "Reply",
        )
        notification.save if notification.valid?
      end
    end

    def delete_notification_favorite_reply(current_user, reply)
      favorite_reply_notification = Notification.find_by(action_user_id: current_user.id, reply_id: reply.id, action_type: "Favorite")
      if favorite_reply_notification
        favorite_reply_notification.destroy
      end
    end



end
