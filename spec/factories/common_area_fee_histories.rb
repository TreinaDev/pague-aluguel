FactoryBot.define do
  factory :common_area_fee_history do
    fee_cents { 1 }
    user { 'MyString' }
    common_area { nil }
  end
end
