class Review < ApplicationRecord

  belongs_to :user
  belongs_to :book
  has_many :favorite_reviews, dependent: :destroy
  has_many :browsing_histories, dependent: :destroy
  has_many :notifications,              dependent: :destroy


  validates :rating,   presence: true
  validates :title,    presence: true, length: { maximum: 60 }
  validates :content,  presence: true, length: { maximum: 1000 }

end
