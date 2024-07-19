FactoryBot.define do
  factory :property_owner do
    email { 'nakedsnake@mgs.com' }
    password { 'bigboss' }
    first_name { 'Severus' }
    last_name { 'Snake' }
    document_number { CPF.generate }
  end
end
