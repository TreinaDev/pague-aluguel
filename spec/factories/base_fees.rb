FactoryBot.define do
  factory :base_fee do
    name { 'Taxa de Condomínio' }
    description { 'Manutenção geral do condomínio.' }
    interest_rate { 2 }
    late_fine { 20 }
    fixed { true }
    charge_day { 10.days.from_now }
    recurrence { :monthly }
    condo
  end
end
