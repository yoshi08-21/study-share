FactoryBot.define do
  factory :browsing_history do
    user_id { 1 }
    book_id { nil }
    review_id { nil }
    question_id { nil }
    reply_id { nil }
    subject_question_id { nil }
    subject_question_reply_id { nil }
    survey_id { nil }
    association :user

  end
end
