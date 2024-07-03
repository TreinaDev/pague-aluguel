FactoryBot.define do
  factory :value do
    base_fee
    unit_type_id { 1 }
    price { 200_00 }
  end
end
