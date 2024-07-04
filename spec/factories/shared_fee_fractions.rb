FactoryBot.define do
  factory :shared_fee_fraction do
    value_cents { 1 }
    shared_fee { nil }
    unit_id { nil }
  end
end
