FactoryBot.define do
  factory :common_area do
    name { 'Churrasqueira' }
    description { 'Área aberta perfeita para dias ensolarados' }
    max_capacity { 30 }
    usage_rules { '' }
    fee_cents { 0 }
  end
end
