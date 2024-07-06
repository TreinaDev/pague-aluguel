require 'rails_helper'

describe 'usuario loga como admin' do
  it 'com sucesso' do
    FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)

    visit root_path
    within 'nav' do
      click_on 'Login'
    end
    click_on 'Administrador'

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
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)

    visit root_path
    within 'nav' do
      click_on 'Login'
    end
    click_on 'Administrador'

    within 'form' do
      fill_in 'E-mail', with: 'xuxu@mail.com'
      fill_in 'Senha', with: '123456'
      click_on 'Login'
    end

    expect(page).to have_content 'E-mail ou senha inválidos.'
    expect(page).not_to have_content 'Login efetuado com sucesso'

    within 'nav' do
      expect(page).not_to have_content 'Fulano Da Costa'
      expect(page).not_to have_content 'Logout'
    end
  end
end

describe 'admin faz logout' do
  it 'com sucesso' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)

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
