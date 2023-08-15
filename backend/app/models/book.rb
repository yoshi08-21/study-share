class Book < ApplicationRecord

  include CustomValidation

  attr_accessor :is_favorite
  attr_accessor :favorite_book_id
  attr_accessor :avg_rating

  belongs_to :user
  has_many :reviews, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :favorite_books, dependent: :destroy

  has_one_attached :image

  validates :name,      presence: true, length: { maximum: 50 }, uniqueness: { message: 'この参考書は既に登録されています' }
  validates :author,    presence: true, length: { maximum: 25 }
  validates :publisher, length: { maximum: 25 }
  validates :subject,   presence: true
  validates :description, length: { maximum: 1000 }



end

