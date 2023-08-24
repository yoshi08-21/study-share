FactoryBot.define do
  factory :survey do
    title { "参考書選び" }
    content { "どの参考書がおすすめですか？" }
    option1 { "参考書1" }
    option2 { "参考書2" }
    option3 { "参考書3" }
    option4 { "参考書4" }
    status { false }
    user_id { 1 }
    genre { "英語" }
    association :user

  end
end
