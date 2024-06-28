FactoryBot.define do
  factory :common_area do
    name { 'MyString' }
    description { 'some description' }
    max_capacity { 30 }
    usage_rules { 'Some usage rules' }
    fee_cents { 0 }
  end
end
