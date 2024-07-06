require 'rails_helper'

describe 'Proprietário tenta se cadastrar' do
  it 'com CPF inválido' do
    cpf = CPF.generate
    allow(Faraday).to receive(:get).and_return(instance_double('Faraday::Response', success?: false))
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)

    visit root_path
    within 'nav' do
      click_on 'Login'
    end
    click_on 'Proprietário'
    click_on 'criar conta'
    fill_in 'E-mail', with: 'propertytest@mail.com'
    fill_in 'CPF', with: cpf
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme a senha', with: 'password'
    click_on 'Cadastrar'

    expect(page).to have_content 'CPF inválido'
  end

  it 'e realiza o cadastro com sucesso' do
    cpf = CPF.generate
    allow(Faraday).to receive(:get).and_return(instance_double('Faraday::Response', success?: true))
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)

    visit root_path
    click_on 'Login'
    click_on 'Proprietário'
    click_on 'criar conta'
    fill_in 'E-mail', with: 'propertytest@mail.com'
    cpf.each_char { |char| find(:css, "input[id$='property_owner_document_number']").send_keys(char) }
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme a senha', with: 'password'
    click_on 'Cadastrar'

    expect(page).to have_content('Cadastro realizado com sucesso.')
    expect(PropertyOwner.first.document_number).to eq cpf
  end
end
