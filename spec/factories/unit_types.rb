FactoryBot.define do
  factory :unit_type do
    description { "MyString" }
    area { 1 }
    ideal_fraction { 1.5 }
    condo { nil }
  end
end
