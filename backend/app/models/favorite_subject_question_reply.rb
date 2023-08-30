class FavoriteSubjectQuestionReply < ApplicationRecord

  belongs_to :user
  belongs_to :subject_question_reply

  validates_uniqueness_of :subject_question_reply_id, scope: :user_id


end
