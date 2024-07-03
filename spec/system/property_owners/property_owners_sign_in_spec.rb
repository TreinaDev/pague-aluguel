require 'rails_helper'

describe 'Proprietário tenta fazer login' do
  it 'com sucesso e visualiza seu cpf e email' do
    cpf = CPF.generate
    PropertyOwner.create!(email: 'propertyownertest@mail.com', password: '123456', document_id: cpf)

    visit root_path
    click_on 'Login de Proprietário'
    fill_in 'E-mail', with: 'propertyownertest@mail.com'
    fill_in 'Senha', with: '123456'
    click_on 'Entrar'

    expect(page).to have_content 'Login efetuado com sucesso'
    expect(page).to have_content cpf
    expect(page).to have_content 'propertyownertest@mail.com'
  end

  it 'e preenche os campos de forma inválida' do
    visit root_path
    click_on 'Login de Proprietário'
    fill_in 'E-mail', with: 'teste'
    fill_in 'Senha', with: '123'
    click_on 'Entrar'

    expect(current_path).to eq new_property_owner_session_path
  end
end
