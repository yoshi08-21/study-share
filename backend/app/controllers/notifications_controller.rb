class NotificationsController < ApplicationController

  include SharedActions::DateTime


  def index
    current_user = User.find_by(id: params[:current_user_id])
    return head :not_found unless current_user

    notifications = Notification.includes(
      :action_user,
      review: :user,
      question: :user,
      reply: [:user, :question],
      subject_question: :user,
      subject_question_reply: [:user, :subject_question],
      survey: :user
    ).where(target_user_id: current_user.id).order(created_at: :desc)
    return head :not_found unless notifications

    render json: notifications, include: [
      :action_user,
      review: { include: :user },
      question: { include: :user },
      reply: { include: [:user, :question] },
      subject_question: { include: :user },
      subject_question_reply: { include: [:user, :subject_question] },
      survey: { include: :user }
    ]
    notifications.where(is_checked: false).each do |notification|
      notification.update_attribute(:is_checked, true)
    end
    delete_over100_notifications(notifications)
  end

  def check_unread_notifications
    # 404を返すと未ログイン時にエラーになる
    current_user = User.find_by(id: params[:current_user_id])
    return head :no_content unless current_user

    unread_notifications = Notification.where(target_user_id: current_user.id, is_checked: false)
    # セーフナビゲーション演算子
    if unread_notifications&.any?
      head :ok
    else
      head :no_content
    end
  end


  private

    def delete_over100_notifications(notifications)
      if notifications.count > 100
        old_notifications = notifications.slice(0, notifications.length - 100)
        old_notifications.each do |old_notification|
          old_notification.destroy
        end
      end
    end

end

