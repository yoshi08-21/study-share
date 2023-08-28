FactoryBot.define do
  factory :notification do
    action_user_id { 1 }
    target_user_id { 2 }
    review_id { nil }
    question_id { nil }
    reply_id { nil }
    subject_question_id { nil }
    subject_question_reply_id { nil }
    survey_id { nil }
    action_type { "" }
    action_to { "" }
    is_checked { false }
    association :action_user, factory: :user
    association :target_user, factory: :user
  end
end
