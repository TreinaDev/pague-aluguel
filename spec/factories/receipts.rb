FactoryBot.define do
  factory :receipt do
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec/support/pdf/Comprovante-teste.pdf'), 'application/pdf') }
  end
end
