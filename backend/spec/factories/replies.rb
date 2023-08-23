FactoryBot.define do
  factory :reply do
    content { "この参考書はすごくおすすめです！" }
    user_id { 1 }
    question_id { 1 }
    association :user
    association :question
  end
end
