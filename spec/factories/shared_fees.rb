FactoryBot.define do
  factory :shared_fee do
    description { 'Conta de Luz' }
    issue_date { 10.days.from_now.to_date }
    total_value_cents { 1000 }
    condo
  end
end
