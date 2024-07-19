FactoryBot.define do
  factory :nd_certificate do
    unit_id { 1 }
    issue_date { Time.zone.now }
  end
end
