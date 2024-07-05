require 'rails_helper'

describe 'usuario loga como admin' do
  it 'com sucesso' do
    FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')

    visit root_path
    within 'nav' do
      click_on 'Login'
    end

    within 'form' do
      fill_in 'E-mail', with: 'admin@mail.com'
      fill_in 'Senha', with: '123456'
      click_on 'Login'
    end

    expect(page).to have_content 'Login efetuado com sucesso'

    within 'nav' do
      expect(page).to have_content 'Fulano Da Costa'
      expect(page).to have_button 'Logout'
    end
  end

  it 'falha quando login inexistente' do
    visit root_path
    within 'nav' do
      click_on 'Login'
    end

    within 'form' do
      fill_in 'E-mail', with: 'example@mail.com'
      fill_in 'Senha', with: 'errado456'
      click_on 'Login'
    end

    expect(page).to have_content 'E-mail ou senha inválidos.'
    expect(page).not_to have_content 'Login efetuado com sucesso'

    within 'nav' do
      expect(page).not_to have_content 'Fulano Da Costa'
      expect(page).not_to have_content 'Logout'
      expect(page).to have_content 'Login'
    end
  end
end

describe 'admin faz logout' do
  it 'com sucesso' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')

    login_as admin, scope: :admin
    visit root_path
    within 'nav' do
      click_on 'Logout'
    end

    expect(page).to have_content 'Logout efetuado com sucesso'
    within 'nav' do
      expect(page).not_to have_content 'Fulano Da Costa'
      expect(page).to have_link 'Login'
    end
  end
end
