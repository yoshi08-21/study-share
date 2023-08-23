FactoryBot.define do
  factory :question do
    title { "この本のおすすめの点はなんですか？" }
    content { "教えて下さい" }
    subject { "現代文" }
    user_id { 1 }
    book_id { 1 }
    association :user
    association :book

    trait :other_question do
      title { "この本を使っていて" }
      content { "どんなときに良い本だと感じましたか？" }
      user_id { 100 }
    end
  end
end
