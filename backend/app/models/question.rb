class Question < ApplicationRecord

  include CustomValidation

  belongs_to :user
  belongs_to :book

  has_many :replies,            dependent: :destroy
  has_many :favorite_questions, dependent: :destroy
  has_many :browsing_histories, dependent: :destroy
  has_many :notifications,      dependent: :destroy

  has_one_attached :image

  validates :title,    presence: true, length: { maximum: 60 }
  validates :content,  presence: true, length: { maximum: 1000 }
  validates :subject,  presence: true

end
