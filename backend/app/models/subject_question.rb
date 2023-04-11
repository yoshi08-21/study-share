class SubjectQuestion < ApplicationRecord

  belongs_to :user
  has_many :subject_question_replies

  validates :title,    presence: true, length: { maximum: 60 }
  validates :content,  presence: true, length: { maximum: 1000 }
  validates :subject,  presence: true
  validates :user_id,    presence: true

end
