require 'rails_helper'

RSpec.describe PropertyOwner, type: :model do
  context 'shoulda_matchers' do
    before do
      allow_any_instance_of(PropertyOwner).to receive(:cpf_valid?).and_return(true)
    end
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:document_number) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_uniqueness_of(:document_number) }
  end

  it 'com CPF válido' do
    cpf = CPF.generate
    fake_response = double('faraday_response', success?: true, body: 'Proprietário')

    allow(Faraday).to(
      receive(:get).with("#{Rails.configuration.api['base_url']}/property?cpf=#{cpf}").and_return(fake_response)
    )

    owner = PropertyOwner.new(
      email: 'solidsnake@mgs.com',
      password: 'password',
      document_number: cpf,
      first_name: 'Fulano',
      last_name: 'da Costa'
    )

    expect(owner).to be_valid
  end

  it 'com CPF inválido' do
    cpf = CPF.generate
    fake_response = double('faraday_response', success?: false, body: 'Proprietário')

    allow(Faraday).to(
      receive(:get).with("#{Rails.configuration.api['base_url']}/property?cpf=#{cpf}").and_return(fake_response)
    )

    owner = PropertyOwner.new(
      email: 'solidsnake@mgs.com',
      password: 'password',
      document_number: cpf,
      first_name: 'Fulano',
      last_name: 'da Costa'
    )

    expect(owner).to_not be_valid
  end
end
