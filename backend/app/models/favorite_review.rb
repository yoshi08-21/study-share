class FavoriteReview < ApplicationRecord

  belongs_to :user
  belongs_to :review

  validates :user_id, presence: true
  validates :review_id, presence: true
  validates_uniqueness_of :review_id, scope: :user_id


end
