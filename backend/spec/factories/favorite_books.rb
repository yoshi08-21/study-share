FactoryBot.define do
  factory :favorite_book do
    user_id { 1 }
    book_id { 1 }
    association :user
    association :book
  end
end
