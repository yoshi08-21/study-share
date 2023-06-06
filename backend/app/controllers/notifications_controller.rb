class NotificationsController < ApplicationController
  def index
    current_user = User.find_by(id: params[:current_user_id])
    notifications = Notification.includes(
      review: :user,
      question: :user,
      reply: [:user, :question],
      subject_question: :user,
      subject_question_reply: [:user, :subject_question]
    ).where(target_user_id: current_user.id).order(created_at: :desc)
    if notifications
      render json: notifications, include: [
        :action_user,
        review: { include: :user },
        question: { include: :user },
        reply: { include: [:user, :question] },
        subject_question: { include: :user },
        subject_question_reply: { include: [:user, :subject_question] }
      ]
      notifications.where(is_checked: false).each do |notification|
        notification.update_attribute(:is_checked, true)
      end
      delete_over100_notifications(notifications)
    else
      render json: notifications.errors
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

