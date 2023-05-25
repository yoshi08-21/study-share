class SubjectQuestionReply < ApplicationRecord

  belongs_to :user
  belongs_to :subject_question

  has_many :favorite_subject_question_replies, dependent: :destroy

  validates :content,  presence: true, length: { maximum: 1000 }
  validates :user_id,  presence: true
  validates :subject_question_id,  presence: true

end
