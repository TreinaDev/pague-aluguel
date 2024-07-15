require 'rails_helper'

describe 'Proprietário tenta fazer login' do
  it 'com sucesso e visualiza seu cpf e email' do
    cpf = CPF.generate
    allow(Faraday).to receive(:get).and_return(instance_double('Faraday::Response', success?: true))
    property_owner = create(:property_owner, email: 'propertyownertest@mail.com', password: '123456',
                                             document_number: cpf)

    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)

    units = []
    units << Unit.new(id: 1, area: 100, floor: 2, number: 3, unit_type_id: 1)
    allow(Unit).to receive(:find).and_return(units[0])
    allow(Unit).to receive(:find_all_by_owner).and_return(units)

    visit root_path
    within 'nav' do
      click_on 'Login'
    end
    click_on 'Proprietário'

    within 'form' do
      fill_in 'E-mail', with: property_owner.email
      fill_in 'Senha', with: '123456'
      click_on 'Login'
    end

    expect(page).to have_content 'Login efetuado com sucesso'
    expect(page).to have_content CPF.new(cpf).formatted
    expect(page).to have_content property_owner.email
  end

  it 'e preenche os campos de forma inválida' do
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)

    visit root_path
    within 'nav' do
      click_on 'Login'
    end
    click_on 'Proprietário'

    within 'form' do
      fill_in 'E-mail', with: 'email@fake'
      fill_in 'Senha', with: '123456'
      click_on 'Login'
    end

    within 'nav' do
      expect(page).not_to have_content 'email@fake'
      expect(page).not_to have_button 'Logout'
    end
    expect(page).to have_content 'E-mail ou senha inválidos.'
    expect(page).to have_button 'Login'
  end
end
