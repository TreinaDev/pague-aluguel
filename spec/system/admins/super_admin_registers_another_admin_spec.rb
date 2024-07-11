require 'rails_helper'

describe 'super admin registra outro admin' do
  it 'com sucesso' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa', super_admin: true)
    cpf = CPF.generate
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)

    login_as admin, scope: :admin
    visit root_path

    click_on 'novo administrador'

    fill_in 'E-mail', with: 'joaoalmeida@mail.com'
    fill_in 'Senha', with: 'password123'
    fill_in 'Confirme a senha', with: 'password123'
    fill_in 'Nome', with: 'João'
    fill_in 'Sobrenome', with: 'Almeida'
    cpf.each_char { |char| find(:css, "input[id$='admin_document_number']").send_keys(char) }
    attach_file 'Insira sua foto de perfil', Rails.root.join('spec/support/images/reuri.jpeg')
    click_on 'Cadastrar'

    expect(page).to have_content 'Cadastro realizado com sucesso.'
    expect(page).to have_content 'João Almeida'
    expect(current_path).to eq root_path
  end

  it 'falha quando faltam atributos' do
    admin = FactoryBot.create(:admin, super_admin: true)
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)

    login_as admin, scope: :admin
    visit root_path

    click_on 'novo administrador'
    fill_in 'E-mail', with: 'another@mail.com'
    fill_in 'Senha', with: 'example123456'
    fill_in 'Confirme a senha', with: 'example123456'
    click_on 'Cadastrar'

    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Sobrenome não pode ficar em branco'
    expect(page).to have_content 'CPF não pode ficar em branco'
    expect(page).to have_content 'Não foi possível salvar administrador'
    expect(page).not_to have_content 'Bem Vindo! Você se registrou com sucesso!'
  end

  it 'não consegue ver o botão de registro caso não seja super admin' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa', super_admin: false)
    CPF.generate
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)

    login_as admin, scope: :admin
    visit root_path

    expect(page).not_to have_link 'novo administrador'
  end

  it 'e este novo admin é um super' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa', super_admin: true)
    cpf = CPF.generate
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)

    login_as admin, scope: :admin
    visit root_path

    click_on 'novo administrador'

    fill_in 'E-mail', with: 'joaoalmeida@mail.com'
    fill_in 'Senha', with: 'password123'
    fill_in 'Confirme a senha', with: 'password123'
    fill_in 'Nome', with: 'João'
    fill_in 'Sobrenome', with: 'Almeida'
    cpf.each_char { |char| find(:css, "input[id$='admin_document_number']").send_keys(char) }
    check 'Acesso Geral'
    attach_file 'Insira sua foto de perfil', Rails.root.join('spec/support/images/reuri.jpeg')
    click_on 'Cadastrar'

    expect(page).to have_content 'Cadastro realizado com sucesso.'
    expect(page).to have_content 'João Almeida'
    expect(current_path).to eq root_path
    expect(Admin.last.super_admin).to eq true
  end
end
