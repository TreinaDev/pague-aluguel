FactoryBot.define do
  factory :shared_fee_fraction do
    value_cents { 1 }
    shared_fee { nil }
    unit { nil }
  end
end
