class Reply < ApplicationRecord

  belongs_to :user
  belongs_to :question

  has_many :favorite_replies, dependent: :destroy

  validates :content,  presence: true, length: { maximum: 1000 }
  validates :user_id,  presence: true
  validates :question_id,  presence: true


end
