require 'rails_helper'

describe 'usuario loga como admin' do
  it 'com sucesso' do
    Admin.create!(
      email: 'example@mail.com',
      password: 'example123456',
      first_name: 'Fulano',
      last_name: 'Da Costa',
      document_number: CPF.generate
    )

    visit root_path
    within('nav') do
      click_on 'Login'
    end

    within('form') do
      fill_in 'E-mail', with: 'example@mail.com'
      fill_in 'Senha', with: 'example123456'
      click_on 'Log in'
    end

    expect(page).to have_content('Login efetuado com sucesso')

    within('nav') do
      expect(page).to have_content('Fulano Da Costa')
      expect(page).to have_content('Logout')
    end
  end

  it 'falha quando login inexistente' do
    visit root_path
    within('nav') do
      click_on 'Login'
    end

    within('form') do
      fill_in 'E-mail', with: 'example@mail.com'
      fill_in 'Senha', with: 'errado456'
      click_on 'Log in'
    end

    expect(page).to have_content('E-mail ou senha inválidos.')
    expect(page).not_to have_content('Login efetuado com sucesso')

    within('nav') do
      expect(page).not_to have_content('Fulano Da Costa')
      expect(page).not_to have_content('Logout')
      expect(page).to have_content('Login')
    end
  end
end

describe 'admin faz logout' do
  it 'com sucesso' do
    admin = Admin.create!(
      email: 'example@mail.com',
      password: 'example123456',
      first_name: 'Fulano',
      last_name: 'Da Costa',
      document_number: CPF.generate
    )

    login_as(admin, scope: :admin)
    visit root_path
    within('nav') do
      click_on 'Logout'
    end

    expect(page).to have_content('Logout efetuado com sucesso')
    within('nav') do
      expect(page).to have_content('Login')
      expect(page).not_to have_content('Fulano Da Costa')
    end
  end
end
