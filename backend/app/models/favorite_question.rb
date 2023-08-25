class FavoriteQuestion < ApplicationRecord

  belongs_to :user
  belongs_to :question

  validates :user_id, presence: true
  validates :question_id, presence: true
  validates_uniqueness_of :question_id, scope: :user_id


end

