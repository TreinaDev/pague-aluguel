FactoryBot.define do
  factory :common_area_fee_history do
    fee_cents { 500_00 }
    user { 'ikki.phoenix@saintseiya.com' }
    common_area { nil }
  end
end
