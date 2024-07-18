FactoryBot.define do
  factory :receipt do
    name { 'Comprovante' }
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec/support/pdf/Comprovante-teste.pdf'), 'application/pdf') }
  end
end
