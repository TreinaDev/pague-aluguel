FactoryBot.define do
  factory :single_charge do
    unit_id { 1 }
    value_cents { 1 }
    issue_date { "2024-07-10" }
    description { "MyString" }
    charge_type { 1 }
    condo_id { 1 }
  end
end
