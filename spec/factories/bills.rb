FactoryBot.define do
  factory :bill do
    unit_id { 1 }
    issue_date { '2024-07-10' }
    due_date { '2024-07-10' }
    base_fee_value_cents { 1 }
    shared_fee_value_cents { 1 }
    total_value_cents { 1 }
    condo_id { 1 }
    status { 0 }
  end
end
