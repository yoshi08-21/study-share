class SubjectQuestionRepliesController < ApplicationController

  def index
    subject_question = SubjectQuestion.find_by(id: params[:subject_question_id])
    subject_question_replies = subject_question.subject_question_replies.includes(:user)
    if subject_question_replies
      render json: subject_question_replies, include: "user"
    else
      render json: subject_question_replies.errors
    end
  end

  def show
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




end
