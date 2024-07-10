require 'rails_helper'

describe 'admin edita sua propria conta' do
  it 'com sucesso' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)

    login_as admin, scope: :admin
    visit root_path

    find('#edit-profile').click

    fill_in 'Nome', with: 'Ciclano'
    fill_in 'Sobrenome', with: 'Da Silva'
    attach_file 'Insira sua foto de perfil', Rails.root.join('spec/support/images/reuri.jpeg')
    click_on 'Atualizar'

    expect(page).to have_content 'A sua conta foi atualizada com sucesso.'
    expect(page).to have_content 'Ciclano Da Silva'
    expect(page).to have_css "img[src*='reuri.jpeg']"
    expect(page).not_to have_content 'Fulano Da Costa'
  end

  it 'e falha por parametro incorreto' do
    admin = FactoryBot.create(:admin)

    login_as admin, scope: :admin
    visit edit_admin_registration_path(admin)

    fill_in 'Nome', with: ''
    fill_in 'Sobrenome', with: ''
    click_on 'Atualizar'

    expect(page).to have_content 'Não foi possível salvar administrador'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Sobrenome não pode ficar em branco'
  end
end

describe 'admin tenta editar outra conta' do
  it 'e não encontra section de admins' do
    admin = FactoryBot.create(:admin)
    FactoryBot.create(:admin,
                      email: 'outroadmin@mail.com',
                      password: '123456',
                      first_name: 'Ciclano',
                      last_name: 'Da Silva',
                      document_number: CPF.generate)
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)

    login_as admin, scope: :admin
    visit root_path

    expect(page).not_to have_content 'Administradores'
    expect(page).not_to have_content 'Ciclano Da Silva'
  end
end
