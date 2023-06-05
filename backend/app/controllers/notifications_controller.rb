class NotificationsController < ApplicationController
  def index
    current_user = User.find_by(id: params[:current_user_id])
    notifications = Notification.includes(
      review: :user,
      question: :user,
      reply: [:user, :question],
      subject_question: :user,
      subject_question_reply: [:user, :subject_question]
    ).where(target_user_id: current_user.id)
    if notifications
      render json: notifications, include: [
        :action_user,
        review: { include: :user },
        question: { include: :user },
        reply: { include: [:user, :question] },
        subject_question: { include: :user },
        subject_question_reply: { include: [:user, :subject_question] }
      ]
    else
      render json: notifications.errors
    end
  end
end

    # notifications = Notification.includes(
    #     :action_user,
    #     { question: [:user, :book] },
    #     { review: :book },
    #     { reply: :question },
    #     { subject_question: :user },
    #     { subject_question_reply: :subject_question }
    #   ).where(target_user_id: current_user.id)
