FactoryBot.define do
  factory :admin do
    email { 'admin@mail.com' }
    password { '123456' }
    first_name { 'João' }
    last_name { 'Almeida' }
    document_number { CPF.generate }
  end
end
