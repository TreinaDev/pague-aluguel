FactoryBot.define do
  factory :unit_type do
    description { 'Apartamento da Cobertura' }
    area { 100 }
    ideal_fraction { 0.5 }
    condo
  end
end
