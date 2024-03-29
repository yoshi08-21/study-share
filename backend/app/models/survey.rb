class Survey < ApplicationRecord

  include CustomValidation

  belongs_to :user

  has_many :survey_answers, dependent: :destroy
  has_many :favorite_surveys, dependent: :destroy
  has_many :browsing_histories, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_one_attached :image

  validates :title,  presence: true, length: { maximum: 50 }
  validates :content,  presence: true, length: { maximum: 1000 }
  validates :option1,  presence: true, length: { maximum: 50 }
  validates :option2,  presence: true, length: { maximum: 50 }
  validates :option3, length: { maximum: 50 }
  validates :option4, length: { maximum: 50 }

end
