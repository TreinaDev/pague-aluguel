FactoryBot.define do
  factory :single_charge do
    unit_id { 1 }
    value_cents { 5000 }
    issue_date { Time.zone.now }
    description { 'Detalhes de uma cobrança avulsa ' }
    charge_type { 0 }
    condo_id { 1 }
    common_area_id { nil }
  end
end
