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

  def show
    book = Book.find_by(id: params[:book_id])
    question = Question.includes(:user).find_by(id: params[:question_id])
    reply = Reply.includes(:user).find_by(id: params[:id])
    if reply
      render json: {
        book: book,
        question: question.as_json(include: :user),
        reply: reply.as_json(include: :user),
      }
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


  private

    def reply_params
      params.require(:reply).permit(:content, :user_id, :question_id)
    end

end
