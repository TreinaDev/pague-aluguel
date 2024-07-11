FactoryBot.define do
  factory :single_charge do
    unit_id { 1 }
    value_cents { 5000 }
    issue_date { 5.days.from_now.to_date }
    description { 'Detalhes de uma cobrança avulsa ' }
    charge_type { 0 }
    condo_id { 1 }
    common_area_id { nil }
  end
end
