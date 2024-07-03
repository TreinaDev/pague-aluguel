FactoryBot.define do
  factory :property_owner do
    email { 'nakedsnake@mgs.com' }
    password { 'bigboss' }
    document_id { CPF.generate }
  end
end
