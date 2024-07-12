require 'rails_helper'

describe 'Super Admin busca condomínio pelo nome' do
  it 'com sucesso' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    condos << Condo.new(id: 2, name: 'Residencial Jardim Europa', city: 'Maceió')
    condos << Condo.new(id: 3, name: 'Edifício Monte Verde', city: 'Recife')
    condos << Condo.new(id: 4, name: 'Condomínio Lagoa Verde', city: 'Caxias do Sul')
    allow(Condo).to receive(:all).and_return(condos)

    login_as admin, scope: :admin
    visit root_path
    fill_in 'Busque um condomínio',	with: 'verde'
    click_on 'Buscar'

    expect(page).to have_content 'Resultados para verde'
    expect(page).to have_content 'Edifício Monte Verde'
    expect(page).to have_content 'Condomínio Lagoa Verde'
  end

  it 'e retorna alerta se nao encontrar condominios' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:all).and_return(condos)

    login_as admin, scope: :admin
    visit root_path
    fill_in 'Busque um condomínio',	with: 'Teste'
    click_on 'Buscar'

    expect(page).to have_content 'Nenhum condomínio encontrado.'
    expect(page).not_to have_content 'Você precisa buscar por um nome de condomínio.'
  end

  it 'e retorna alerta caso o termo da busca seja vazio' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:all).and_return(condos)

    login_as admin, scope: :admin
    visit root_path
    fill_in 'Busque um condomínio',	with: ''
    click_on 'Buscar'

    expect(page).to have_content 'Você precisa buscar por um nome de condomínio.'
  end

  it 'e ele não ve o campo de busa por não ter acesso de super admin' do
    admin = create(:admin, super_admin: false)
    condos = []
    condos << Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:all).and_return(condos)

    login_as admin, scope: :admin
    visit root_path

    expect(page).not_to have_field 'Busque um condomínio'
    expect(page).not_to have_button 'Buscar'
  end
end
