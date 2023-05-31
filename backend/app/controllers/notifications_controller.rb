class NotificationsController < ApplicationController
  def index
    current_user = User.find_by(id: params[:current_user_id])
    notifications = Notification.where(target_user_id: current_user.id)
    if notifications
      render json: notifications
    else
      render json: notifications.errors
    end
  end
end
