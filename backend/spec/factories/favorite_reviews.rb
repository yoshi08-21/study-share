FactoryBot.define do
  factory :favorite_review do
    user_id { 1 }
    review_id { 1 }
    association :user
    association :review
  end
end
