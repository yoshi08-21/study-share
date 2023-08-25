FactoryBot.define do
  factory :favorite_question do
    user_id { 1 }
    question_id { 1 }
    association :user
    association :question
  end
end
