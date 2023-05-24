class Question < ApplicationRecord

  belongs_to :user
  belongs_to :book
  has_many :favorite_questions, dependent: :destroy
  has_many :replies


  validates :title,    presence: true, length: { maximum: 60 }
  validates :content,  presence: true, length: { maximum: 1000 }
  validates :subject,  presence: true
  validates :user_id,    presence: true
  validates :book_id,    presence: true

end
