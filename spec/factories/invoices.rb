FactoryBot.define do
  factory :invoice do
    customer
    merchant
    status { ["shipped", "pending", "returned"].sample }
  end
end