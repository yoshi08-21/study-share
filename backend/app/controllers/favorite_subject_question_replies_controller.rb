class FavoriteSubjectQuestionRepliesController < ApplicationController

  def create
    current_user = User.find_by(id: params[:user_id])
    subject_question_reply = SubjectQuestionReply.find_by(id: params[:subject_question_reply_id])
    favorite_subject_question_reply = current_user.favorite_subject_question_replies.build(subject_question_reply_id: subject_question_reply.id)
    if !exist_favorite_subject_question_reply?(current_user, subject_question_reply)
      favorite_subject_question_reply.save
      render json: favorite_subject_question_reply, status: 200
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end

  def destroy
    current_user = User.find_by(id: params[:user_id])
    subject_question_reply = SubjectQuestionReply.find_by(id: params[:subject_question_reply_id])
    favorite_subject_question_reply = FavoriteSubjectQuestionReply.find_by(user_id: current_user.id, subject_question_reply_id: subject_question_reply.id)
    if favorite_subject_question_reply.destroy
      render json: { status: :ok }
    else
      render json: { error: "エラーが発生しました" }, status: 400
    end
  end


  private

    def exist_favorite_subject_question_reply?(current_user, subject_question_reply)
      current_user.fav_subject_question_replies.include?(subject_question_reply)
    end


end
