class FavoriteSurvey < ApplicationRecord
  belongs_to :user
  belongs_to :survey

  validates_uniqueness_of :survey_id, scope: :user_id

end
