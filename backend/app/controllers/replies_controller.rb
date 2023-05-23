class RepliesController < ApplicationController

  def index
    question = Question.find_by(id: params[:question_id])
    replies = question.replies.includes(:user)
    if replies
      render json: replies, include: "user"
    else
      render json: replies.errors
    end
  end

end
