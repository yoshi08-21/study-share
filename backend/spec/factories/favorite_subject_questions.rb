FactoryBot.define do
  factory :favorite_subject_question do
    user_id { 1 }
    subject_question_id { 1 }
    association :user
    association :subject_question
  end
end
