class SurveyAnswer < ApplicationRecord

  belongs_to :user
  belongs_to :survey

  validates :selected_option,  presence: true

end
