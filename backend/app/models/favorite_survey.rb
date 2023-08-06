class FavoriteSurvey < ApplicationRecord
  belongs_to :user
  belongs_to :survey

  validates :user_id, presence: true
  validates :user_id, presence: true
end
