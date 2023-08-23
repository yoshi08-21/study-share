class Review < ApplicationRecord

  belongs_to :user
  belongs_to :book
  has_many :favorite_reviews, dependent: :destroy
  has_many :browsing_histories, dependent: :destroy
  has_many :notifications,              dependent: :destroy


  validates :rating,   presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :title,    presence: true, length: { maximum: 60 }
  validates :content,  presence: true, length: { maximum: 1000 }

end
