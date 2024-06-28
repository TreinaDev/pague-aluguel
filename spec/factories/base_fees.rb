FactoryBot.define do
  factory :base_fee do
    name { 'Taxa de Condomínio'}
    description { 'Manutenção geral do condomínio.' }
    late_payment { 2 }
    late_fee { 20 }
    fixed { true }
    charge_day { 10.days.from_now }
    recurrence { 'Mensal' }
    condo
    value { '9.99' }
  end
end
