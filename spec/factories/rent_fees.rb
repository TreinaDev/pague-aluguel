FactoryBot.define do
  factory :rent_fee do
    tenant_id { 2 }
    owner_id { 1 }
    condo_id { 1 }
    unit_id { 1 }
    value_cents { 20_000 }
    issue_date { '2024-07-16' }
    fine_cents { 1_000 }
    fine_interest { '9.99' }
  end
end
