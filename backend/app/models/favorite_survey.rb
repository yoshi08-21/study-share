class FavoriteSurvey < ApplicationRecord
  belongs_to :user
  belongs_to :survey

  validates :user_id, presence: true
  validates :survey_id, presence: true
  validates_uniqueness_of :survey_id, scope: :user_id

end
