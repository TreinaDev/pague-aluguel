FactoryBot.define do
  factory :bill_detail do
    description { "MyString" }
    value_cents { 1 }
    fee_type { 1 }
    bill { nil }
  end
end
