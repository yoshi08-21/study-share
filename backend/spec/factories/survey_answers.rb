FactoryBot.define do
  factory :survey_answer do
    selected_option { 1 }
    user_id { 1 }
    survey_id { 1 }
    association :user
    association :survey
  end
end
