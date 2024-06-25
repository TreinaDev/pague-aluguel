FactoryBot.define do
  factory :shared_fee do
    description { "MyString" }
    issue_date { "2024-06-25" }
    total_value { 1 }
    condo { nil }
  end
end
