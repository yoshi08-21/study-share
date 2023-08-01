class Survey < ApplicationRecord

  belongs_to :user

  validates :title,  presence: true, length: { maximum: 50 }
  validates :content,  presence: true, length: { maximum: 1000 }
  validates :option1,  presence: true, length: { maximum: 100 }
  validates :option2,  presence: true, length: { maximum: 100 }
  validates :option3, length: { maximum: 100 }
  validates :option4, length: { maximum: 100 }
  validates :user_id,  presence: true

end