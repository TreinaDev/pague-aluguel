FactoryBot.define do
  factory :value do
    base_fee
    unit_type
    price { 200_00 }
  end
end
