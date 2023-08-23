FactoryBot.define do
  factory :subject_question_reply do
    content { "単語を覚えるためには、1ヶ月に6回同じ単語に目を通すのがおすすめです" }
    user_id { 1 }
    subject_question_id { 1 }
    association :user
    association :subject_question
  end
end
