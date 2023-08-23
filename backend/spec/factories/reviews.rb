FactoryBot.define do
  factory :review do
    rating { 5 }
    title { "おすすめ" }
    content { "とても良い本だった。" }
    user_id { 1 }
    book_id { 1 }
    association :user
    association :book

    trait :other_review do
      rating { 2 }
      title { "いまいち" }
      content { "あまりおすすめできない。" }
      user_id { 100 }
    end
  end
end
