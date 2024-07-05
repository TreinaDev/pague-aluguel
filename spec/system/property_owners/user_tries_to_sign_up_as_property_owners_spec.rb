require 'rails_helper'

describe 'Proprietário tenta se cadastrar' do
  it 'com CPF inválido' do
    cpf = CPF.generate
    fake_response = double('faraday_response', status: 404, body: 'CPF inválido')
    allow(Faraday).to receive(:get).and_return(fake_response)

    visit root_path
    click_on 'Registrar-se como Proprietário'
    fill_in 'E-mail', with: 'propertytest@mail.com'
    fill_in 'CPF', with: cpf
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme a senha', with: 'password'
    click_on 'Cadastrar-se'

    expect(page).to have_content 'CPF inválido'
  end

  it 'e realiza o cadastro com sucesso' do
    cpf = CPF.generate
    fake_response = double('faraday_response', status: 200, body: 'Proprietário')
    allow(Faraday).to receive(:get).with("http://localhost:3000/api/v1/property?cpf=#{cpf}").and_return(fake_response)

    visit root_path
    click_on 'Registrar-se como Proprietário'
    fill_in 'E-mail', with: 'propertytest@mail.com'
    fill_in 'CPF', with: cpf
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme a senha', with: 'password'
    click_on 'Cadastrar-se'

    expect(page).to have_content('Bem Vindo! Você se registrou com sucesso!')
    expect(PropertyOwner.first.document_number).to eq cpf
  end
end