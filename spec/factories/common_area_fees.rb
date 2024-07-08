FactoryBot.define do
  factory :common_area_fee do
    value_cents { 100_00 }
    admin { nil }
  end
end
