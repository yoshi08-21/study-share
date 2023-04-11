class SubjectQuestionRepliesController < ApplicationController

  def index
    subject_question_replies = SubjectQuestionReply.all
    if subject_question_replies
      render json: subject_question_replies
    else
      render json: subject_question_replies.errors
    end
  end
end
