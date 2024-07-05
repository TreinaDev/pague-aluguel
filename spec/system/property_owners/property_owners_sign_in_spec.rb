require 'rails_helper'

describe 'Proprietário tenta fazer login' do
  xit 'com sucesso e visualiza seu cpf e email' do
    allow(Faraday).to receive(:get).and_return(instance_double('Faraday::Response', status: 200))
    cpf = CPF.generate
    property_owner = create(:property_owner, email: 'propertyownertest@mail.com', password: '123456',
                                             document_number: cpf)

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
    expect(page).to have_content cpf
    expect(page).to have_content property_owner.email
  end

  it 'e preenche os campos de forma inválida' do
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
    expect(page).to have_button 'Login'
  end
end
