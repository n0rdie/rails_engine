FactoryBot.define do
  factory :transaction do
    invoice
    credit_card_number { Faker::Finance.credit_card }
    credit_card_expiration_date { "12/34" }
    result { ["success", "failed"].sample }
  end
end