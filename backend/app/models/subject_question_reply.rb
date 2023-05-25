class SubjectQuestionReply < ApplicationRecord

  belongs_to :user
  belongs_to :subject_question


  validates :content,  presence: true, length: { maximum: 1000 }
  validates :user_id,  presence: true
  validates :subject_question_id,  presence: true

end
