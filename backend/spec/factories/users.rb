FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "神奈川太郎#{n}" }
    sequence(:email) { |n| "kanagawa#{n}@sample.com" }
    sequence(:uid) { |n| "kanakana1234#{n}" }
  end
end
