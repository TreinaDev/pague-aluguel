FactoryBot.define do
  factory :common_area_fee do
    value_cents { 100_00 }
    admin { nil }
    condo_id { 1 }
  end
end
