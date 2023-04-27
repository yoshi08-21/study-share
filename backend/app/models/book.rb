class Book < ApplicationRecord

belongs_to :user
has_many :reviews
has_many :questions
has_many :favorite_books, dependent: :destroy


validates :name,      presence: true, length: { maximum: 50 }, uniqueness: true
validates :author,    presence: true, length: { maximum: 25 }
validates :publisher, length: { maximum: 25 }
validates :subject,   presence: true


end

