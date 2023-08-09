class SubjectQuestion < ApplicationRecord

  include CustomValidation

  belongs_to :user
  has_many :subject_question_replies
  has_many :favorite_subject_questions, dependent: :destroy
  has_many :browsing_histories, dependent: :destroy
  has_many :notifications,              dependent: :destroy

  has_one_attached :image


  validates :title,    presence: true, length: { maximum: 60 }
  validates :content,  presence: true, length: { maximum: 1000 }
  validates :subject,  presence: true
  validates :user_id,    presence: true

end
