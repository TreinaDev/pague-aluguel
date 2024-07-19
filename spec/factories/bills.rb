FactoryBot.define do
  factory :bill do
    unit_id { 1 }
    issue_date { Time.zone.now }
    due_date { 9.days.from_now }
    base_fee_value_cents { 0 }
    shared_fee_value_cents { 0 }
    single_charge_value_cents { 0 }
    rent_fee_cents { 0 }
    total_value_cents { 0 }
    condo_id { 1 }
    status { 0 }
  end
end
