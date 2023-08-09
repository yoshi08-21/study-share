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
    if reply.image.attached?
      image_url = rails_blob_url(reply.image)
    end
      reply_json = reply.as_json(include: :user).merge(image: image_url)
    if reply
      render json: {
        book: book,
        question: question.as_json(include: :user),
        reply: reply_json,
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
    current_user = User.find_by(id: params[:reply][:user_id])
    question = Question.includes(:user).find_by(id: params[:question_id])
    reply = current_user.replies.build(reply_params)
    reply.question_id = question.id
    if reply.save
      create_notification_reply(current_user, question.user, question, reply)
      render json: reply, status: 200
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end

  def update
    current_user = User.find_by(id: params[:reply][:user_id])
    reply = Reply.find_by(id: params[:id])
    author = reply.user
    if validate_authorship(current_user, author)
      if reply.update(reply_params)
        image_url = reply.image.attached? ? rails_blob_url(reply.image) : nil
        render json: { reply: reply, image_url: image_url }, status: 200
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
    favorite_reply = FavoriteReply.find_by(user_id: current_user.id, reply_id: reply.id) if current_user
    if favorite_reply
      render json: { is_favorite: true, favorite_reply_id: favorite_reply.id }
    else
      render json: false
    end
  end

  def check_existence
    book = Book.find_by(id: params[:book_id])
    question = Question.find_by(id: params[:question_id])
    reply = Reply.find_by(id: params[:id])
    if book && question && reply
      head :ok
    else
      head :not_found
    end
  end


  private

    def reply_params
      params.require(:reply).permit(:content, :user_id, :question_id, :image)
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

    def create_notification_reply(current_user, question_author, question, reply)
      # 質問の投稿者に通知を作成する
      # 自分の質問に自分で返信を投稿したときは通知を作成しない
      if current_user.id != question_author.id
        reply_notification = current_user.sent_notifications.build(
          target_user_id: question_author.id,
          question_id: question.id,
          reply_id: reply.id,
          action_type: "Reply",
          action_to: "Reply"
        )
        reply_notification.save if reply_notification.valid?
      end

      # 返信が投稿されたとき、投稿者以外のその質問に返信しているユーザー全員に通知を作成する
      # 自分には通知を作成しない、質問の投稿者にも通知を作成しない（上の処理で質問の投稿者には通知が作成されるため、２重になってしまう）
      replied_users_id = Reply.select(:user_id).where(question_id: question.id).where.not(user_id: current_user.id).where.not(user_id: question_author.id).distinct
      replied_users_id.each do |replied_user_id|
        notification = current_user.sent_notifications.build(
          target_user_id: replied_user_id.user_id,
          question_id: question.id,
          reply_id: reply.id,
          action_type: "Reply",
          action_to: "Reply"
        )
        notification.save if notification.valid?
      end
    end

end
