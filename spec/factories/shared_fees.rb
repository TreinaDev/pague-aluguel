FactoryBot.define do
  factory :shared_fee do
    description { 'Conta de Luz' }
    issue_date { Time.zone.now }
    total_value_cents { 1000 }
    condo_id { nil }
  end
end
