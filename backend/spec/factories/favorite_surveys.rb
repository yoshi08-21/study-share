FactoryBot.define do
  factory :favorite_survey do
    user_id { 1 }
    survey_id { 1 }
    association :user
    association :survey
  end
end
