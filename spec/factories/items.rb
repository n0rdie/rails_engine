FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence(word_count: 5) }
    unit_price { Faker::Commerce.price(range: 0.01..100.0) }
    merchant
  end
end