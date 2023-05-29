class SubjectQuestionRepliesController < ApplicationController

  def index
    subject_question = SubjectQuestion.find_by(id: params[:subject_question_id])
    subject_question_replies = subject_question.subject_question_replies.includes(:user, :subject_question)
    if subject_question_replies
      render json: subject_question_replies, include: [:user, :subject_question]
    else
      render json: subject_question_replies.errors
    end
  end

  def show
    current_user = User.find_by(id: params[:current_user_id])
    subject_question = SubjectQuestion.includes(:user).find_by(id: params[:subject_question_id])
    subject_question_reply = SubjectQuestionReply.includes(:user).find_by(id: params[:id])
    favorite_subject_question_replies = FavoriteSubjectQuestionReply.where(subject_question_reply_id: subject_question_reply.id)
    favorite_subject_question_replies_count = favorite_subject_question_replies.count
    if subject_question_reply
      render json: {
        subject_question: subject_question.as_json(include: :user),
        subject_question_reply: subject_question_reply.as_json(include: :user),
        favorite_subject_question_replies_count: favorite_subject_question_replies_count
      }
      if current_user && !exist_subject_question_reply_browsing_history?(current_user, subject_question_reply)
        save_subject_question_reply_browsing_history(current_user, subject_question_reply)
      end
    else
      render json: subject_question_reply.errors
    end
  end

  def create
    current_user = User.find_by(id: params[:user_id])
    subject_question = SubjectQuestion.includes(:user).find_by(id: params[:subject_question_id])
    subject_question_reply = current_user.subject_question_replies.build(subject_question_reply_params)
    subject_question_reply.subject_question_id = subject_question.id
    if subject_question_reply.save
      render json: subject_question_reply, status: 200
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end

  def update
    current_user = User.find_by(id: params[:current_user_id])
    subject_question_reply = SubjectQuestionReply.find_by(id: params[:id])
    author = subject_question_reply.user
    if validate_authorship(current_user, author)
      if subject_question_reply.update(subject_question_reply_params)
        render json: subject_question_reply, status: 200
      else
        render json: { error: "エラーが発生しました" }, status: 400
      end
    else
      render json: { error: "権限がありません" }, status: 400
    end
  end

  def destroy
    current_user = User.find_by(id: params[:current_user_id])
    subject_question_reply = SubjectQuestionReply.find_by(id: params[:id])
    author = subject_question_reply.user
    if validate_authorship(current_user, author)
      if subject_question_reply.destroy
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
    subject_question_reply = SubjectQuestionReply.find_by(id: params[:subject_question_reply_id])
    favorite_subject_question_reply = FavoriteSubjectQuestionReply.find_by(user_id: current_user.id, subject_question_reply_id: subject_question_reply.id)
    if favorite_subject_question_reply
      render json: { is_favorite: true, favorite_subject_question_reply_id: favorite_subject_question_reply.id }
    else
      render json: false
    end
  end


  private

    def subject_question_reply_params
      params.require(:subject_question_reply).permit(:content, :user_id, :subject_question_id)
    end

    def exist_subject_question_reply_browsing_history?(current_user, subject_question_reply)
      current_user.watched_subject_question_replies.include?(subject_question_reply)
    end

    def save_subject_question_reply_browsing_history(current_user, subject_question_reply)
      subject_question_reply_browsing_histories = BrowsingHistory.where(user_id: current_user.id).where.not(subject_question_reply_id: nil)
      max_browsing_histories = 10
      if subject_question_reply_browsing_histories.count >= max_browsing_histories
        subject_question_reply_browsing_histories.first.destroy
        current_user.browsing_histories.create(subject_question_reply_id: subject_question_reply.id)
      else
        current_user.browsing_histories.create(subject_question_reply_id: subject_question_reply.id)
      end
    end


end
