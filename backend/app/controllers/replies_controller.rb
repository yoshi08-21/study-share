class RepliesController < ApplicationController

  def index
    question = Question.find_by(id: params[:question_id])
    replies = question.replies.includes(:user, :question)
    if replies
      render json: replies, include: [:user, :question]
    else
      render json: replies.errors
    end
  end

  def show
    current_user = User.find_by(id: params[:current_user_id])
    book = Book.find_by(id: params[:book_id])
    question = Question.includes(:user).find_by(id: params[:question_id])
    reply = Reply.includes(:user).find_by(id: params[:id])
    favorite_replies = FavoriteReply.where(reply_id: reply.id)
    favorite_replies_count = favorite_replies.count
    if reply
      render json: {
        book: book,
        question: question.as_json(include: :user),
        reply: reply.as_json(include: :user),
        favorite_replies_count: favorite_replies_count
      }
      if current_user && !exist_reply_browsing_history?(current_user, reply)
        save_reply_browsing_history(current_user, reply)
      end
    else
      render json: reply.errors
    end
  end

  def create
    current_user = User.find_by(id: params[:user_id])
    question = Question.find_by(id: params[:question_id])
    reply = current_user.replies.build(reply_params)
    reply.question_id = question.id
    if reply.save
      render json: reply, status: 200
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end

  def update
    current_user = User.find_by(id: params[:current_user_id])
    reply = Reply.find_by(id: params[:id])
    author = reply.user
    if validate_authorship(current_user, author)
      if reply.update(reply_params)
        render json: reply, status: 200
      else
        render json: { error: "エラーが発生しました" }, status: 400
      end
    else
      render json: { error: "権限がありません" }, status: 400
    end
  end

  def destroy
    current_user = User.find_by(id: params[:current_user_id])
    reply = Reply.find_by(id: params[:id])
    author = reply.user
    if validate_authorship(current_user, author)
      if reply.destroy
        head :no_content
      else
        render json: { error: "エラーが発生しました" }, status: 400
      end
    else
      render json: { error: "権限がありません" }, status: 400
    end
  end

  def is_favorite
    current_user = User.find_by(id: params[:user_id])
    reply = Reply.find_by(id: params[:reply_id])
    favorite_reply = FavoriteReply.find_by(user_id: current_user.id, reply_id: reply.id)
    if favorite_reply
      render json: { is_favorite: true, favorite_reply_id: favorite_reply.id }
    else
      render json: false
    end
  end


  private

    def reply_params
      params.require(:reply).permit(:content, :user_id, :question_id)
    end

    def exist_reply_browsing_history?(current_user, reply)
      current_user.watched_replies.include?(reply)
    end

    def save_reply_browsing_history(current_user, reply)
      reply_browsing_histories = BrowsingHistory.where(user_id: current_user.id).where.not(reply_id: nil)
      max_browsing_histories = 10
      if reply_browsing_histories.count >= max_browsing_histories
        reply_browsing_histories.first.destroy
        current_user.browsing_histories.create(reply_id: reply.id)
      else
        current_user.browsing_histories.create(reply_id: reply.id)
      end
    end


end
