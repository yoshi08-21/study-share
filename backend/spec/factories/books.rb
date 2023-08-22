FactoryBot.define do
  factory :book do
    sequence(:name) { |n| "参考書#{n}" }
    author { "東京太郎" }
    publisher { "東京出版" }
    subject { "その他" }
    user_id { 1 }


    after(:build) do |user|
      user.image.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "files", "no_image.png")),
        filename: "no_image.png",
        content_type: "image/png"
      )
    end
    # trait :has_five_reviews do
    #   after(:create) { |book| create_list(:review, 5, book: book) }
    # end

    # trait :other_book do
    #   sequence(:name) { |n| "改訂版教科書#{n}" }
    #   author { "文部科学省" }
    #   publisher { "日本" }
    #   subject { "全般" }
    # end

  end
end
