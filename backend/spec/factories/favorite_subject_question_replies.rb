FactoryBot.define do
  factory :favorite_subject_question_reply do
    user_id { 1 }
    subject_question_reply_id { 1 }
    association :user
    association :subject_question_reply
  end
end
