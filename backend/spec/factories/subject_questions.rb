FactoryBot.define do
  factory :subject_question do
    title { "単語の覚え方" }
    content { "おすすめの単語の覚え方はありますか？" }
    subject { "英単語" }
    user_id { 1 }
    association :user
  end
end
