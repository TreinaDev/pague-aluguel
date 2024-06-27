require 'rails_helper'

describe 'admin edita sua propria conta' do
  it 'com sucesso' do
    admin = Admin.create!(
      email: 'admin@mail.com',
      password: '123456',
      first_name: 'Fulano',
      last_name: 'Da Costa',
      document_number: CPF.generate
    )

    login_as(admin, scope: :admin)
    visit root_path

    within('nav') do
      click_on 'Admins'
    end

    within('div#admin_list') do
      click_on 'Fulano Da Costa'
    end
    click_on 'Editar'

    fill_in 'Nome', with: 'Ciclano'
    fill_in 'Sobrenome', with: 'Da Silva'
    click_on 'Salvar'

    expect(page).to have_content('A sua conta foi atualizada com sucesso.')
    expect(page).to have_content('Ciclano Da Silva')
    expect(page).not_to have_content('Fulano Da Costa')
  end
  it 'e falha por parametro incorreto' do
    admin = Admin.create!(
      email: 'admin@mail.com',
      password: '123456',
      first_name: 'Fulano',
      last_name: 'Da Costa',
      document_number: CPF.generate
    )

    login_as(admin, scope: :admin)
    visit edit_admin_registration_path(admin)

    fill_in 'Nome', with: ''
    fill_in 'Sobrenome', with: ''
    click_on 'Salvar'

    expect(page).to have_content('Não foi possível salvar administrador')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Sobrenome não pode ficar em branco')
  end
end
describe 'admin tenta editar outra conta' do
  it 'e não encontra link para edição' do
    admin = Admin.create!(
      email: 'admin@mail.com',
      password: '123456',
      first_name: 'Fulano',
      last_name: 'Da Costa',
      document_number: CPF.generate
    )
    Admin.create!(
      email: 'outroadmin@mail.com',
      password: '123456',
      first_name: 'Ciclano',
      last_name: 'Da Silva',
      document_number: CPF.generate
    )

    login_as(admin, scope: :admin)
    visit root_path

    within('nav') do
      click_on 'Admins'
    end

    within('div#admin_list') do
      click_on 'Ciclano Da Silva'
    end

    expect(page).not_to have_link 'Editar'
  end
end
