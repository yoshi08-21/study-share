class FavoriteRepliesController < ApplicationController

  def create
    current_user = User.find_by(id: params[:user_id])
    reply = Reply.find_by(id: params[:reply_id])
    favorite_reply = current_user.favorite_replies.build(reply_id: reply.id)
    if !exist_favorite_reply?(current_user, reply)
      favorite_reply.save
      render json: favorite_reply, status: 200
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end

  def destroy
    current_user = User.find_by(id: params[:user_id])
    reply = Reply.find_by(id: params[:reply_id])
    favorite_reply = FavoriteReply.find_by(user_id: current_user.id, reply_id: reply.id)
    if favorite_reply.destroy
      render json: { status: :ok }
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end


  private

    def exist_favorite_reply?(current_user, reply)
      current_user.fav_replies.include?(reply)
    end


end
