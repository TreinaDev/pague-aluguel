FactoryBot.define do
  factory :property_owner do
    email { 'nakedsnake@mgs.com' }
    password { 'bigboss' }
    document_number { CPF.generate }
  end
end
