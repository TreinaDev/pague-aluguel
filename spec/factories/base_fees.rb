FactoryBot.define do
  factory :base_fee do
    name { 'Taxa de Condomínio' }
    description { 'Manutenção geral do condomínio.' }
    interest_rate { 2 }
    late_fine { 20 }
    limited { false }
    charge_day { 10.days.from_now }
    recurrence { :monthly }
    condo_id { nil }
    installments { nil }
  end
end
