class RepliesController < ApplicationController

  def index
    replies = Reply.all
    if replies
      render json: replies
    else
      render json: replies.errors
    end
  end

end
