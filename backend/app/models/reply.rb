class Reply < ApplicationRecord

  include CustomValidation

  belongs_to :user
  belongs_to :question

  has_many :favorite_replies, dependent: :destroy
  has_many :browsing_histories, dependent: :destroy
  has_many :notifications,              dependent: :destroy


  has_one_attached :image

  validates :content,  presence: true, length: { maximum: 1000 }

end
