FactoryBot.define do
  factory :favorite_reply do
    user_id { 1 }
    reply_id { 1 }
    association :user
    association :reply
  end
end
