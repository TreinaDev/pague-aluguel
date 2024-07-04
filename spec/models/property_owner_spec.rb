require 'rails_helper'

RSpec.describe PropertyOwner, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:document_id) }
  it { should validate_uniqueness_of(:document_id) }

  # Trasferiria esse teste para um teste de request
  # Faria um teste unitário para validar (document_id.blank? || document_id.length < 11)
  it 'com CPF válido' do
    cpf = CPF.generate
    fake_response = double('faraday_response', status: 200, body: 'Proprietário')
    allow(Faraday).to receive(:get).with("http://localhost:3000/api/v1/property?cpf=#{cpf}").and_return(fake_response)
    owner = PropertyOwner.new(email: 'solidsnake@mgs.com', password: 'password', document_id: cpf)

    expect(owner).to be_valid
  end

  it 'com CPF inválido' do
    cpf = CPF.generate
    fake_response = double('faraday_response', status: 404, body: 'Proprietário')
    allow(Faraday).to receive(:get).with("http://localhost:3000/api/v1/property?cpf=#{cpf}").and_return(fake_response)
    owner = PropertyOwner.new(email: 'solidsnake@mgs.com', password: 'password', document_id: cpf)

    expect(owner).to_not be_valid
  end
end
