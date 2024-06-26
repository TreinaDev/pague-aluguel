require 'rails_helper'

describe 'admin registra outro admin' do
  it 'com sucesso' do
    admin = Admin.create!(
      email: 'example@mail.com',
      password: 'example123456',
      first_name: 'Fulano',
      last_name: 'Da Costa',
      document_number: CPF.generate
    )

    login_as admin, scope: :admin
    visit root_path

    click_on 'Admins'
    click_on 'Registrar novo admin'

    fill_in 'E-mail', with: 'joaoalmeida@mail.com'
    fill_in 'Senha', with: 'password123'
    fill_in 'Confirme a senha', with: 'password123'
    fill_in 'Nome', with: 'João'
    fill_in 'Sobrenome', with: 'Almeida'
    fill_in 'CPF', with: CPF.generate
    click_on 'Registrar'

    expect(current_path).to eq admins_path
    expect(page).to have_content 'Administrador registrado com sucesso'
    expect(page).to have_content 'João Almeida'
  end

  it 'falha quando faltam atributos' do
    admin = Admin.create!(
      email: 'example@mail.com',
      password: 'example123456',
      first_name: 'Fulano',
      last_name: 'Da Costa',
      document_number: CPF.generate
    )

    login_as admin, scope: :admin
    visit root_path

    click_on 'Admins'
    click_on 'Registrar novo admin'

    fill_in 'E-mail', with: 'another@mail.com'
    fill_in 'Senha', with: 'example123456'
    fill_in 'Confirme a senha', with: 'example123456'
    click_on 'Registrar'

    expect(current_path).to eq new_admin_registration_path
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Sobrenome não pode ficar em branco'
    expect(page).to have_content 'CPF não pode ficar em branco'
    expect(page).to have_content 'Não foi possível salvar administrador'
    expect(page).not_to have_content 'Administrador registrado com sucesso'
  end
end
