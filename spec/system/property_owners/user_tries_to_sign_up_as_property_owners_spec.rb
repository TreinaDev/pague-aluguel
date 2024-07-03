require 'rails_helper'

describe 'Proprietário tenta se cadastrar' do
  it 'com CPF inválido' do


    visit root_path
    click_on 'Registrar-se como Proprietário'
    fill_in 'Validar CPF', with: CPF.generate
    click_on 'Validar'

    expect(page).to have_content 'CPF inválido'
  end

  it 'com CPF válido' do
    cpf = CPF.generate
    fake_response = double('faraday_response', status: 200, body: 'Proprietário')
    allow(Faraday).to receive(:get).with("http://localhost:3000/api/v1/property?cpf=#{cpf}").and_return(fake_response)

    visit root_path
    click_on 'Registrar-se como Proprietário'
    fill_in 'Validar CPF', with: cpf
    click_on 'Validar'

    expect(page).to have_content 'Cadastro de Proprietário'
    expect(current_path).to eq new_property_owner_registration_path
  end

  it 'e realiza o cadastro com sucesso' do
    cpf = CPF.generate
    fake_response = double('faraday_response', status: 200, body: 'Proprietário')
    allow(Faraday).to receive(:get).with("http://localhost:3000/api/v1/property?cpf=#{cpf}").and_return(fake_response)

    visit root_path
    click_on 'Registrar-se como Proprietário'
    fill_in 'Validar CPF', with: cpf
    click_on 'Validar'
    fill_in 'E-mail', with: 'propertytest@mail.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme a senha', with: 'password'
    click_on 'Cadastrar-se'

    expect(page).to have_content('Bem Vindo! Você se registrou com sucesso!')
  end

  it 'e tentou acessar a tela de registro sem validar o cpf' do
    visit new_property_owner_registration_path

    expect(page).to have_content 'Valide seu CPF primeiro'
    expect(current_path).to eq new_owner_cpf_validation_path
  end
end
