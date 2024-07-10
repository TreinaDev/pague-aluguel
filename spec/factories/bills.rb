FactoryBot.define do
  factory :bill do
    unit_id { 1 }
    issue_date { "2024-07-10" }
    due_date { "2024-07-10" }
    total_value_cents { 1 }
  end
end
