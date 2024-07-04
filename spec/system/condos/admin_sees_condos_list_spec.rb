require 'rails_helper'

describe 'Admin vê lista de condominios' do
  it 'e vê primeiros condominios por ordem alfabetica' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    condos << Condo.new(id: 2, name: 'Residencial Jardim Europa', city: 'Maceió')
    condos << Condo.new(id: 3, name: 'Edifício Monte Verde', city: 'Recife')
    condos << Condo.new(id: 4, name: 'Condomínio Lagoa Serena', city: 'Caxias do Sul')
    condos << Condo.new(id: 5, name: 'Condomínio Paulista', city: 'São Paulo')
    condos << Condo.new(id: 6, name: 'Edifício Uruguai', city: 'Curitiba')
    allow(Condo).to receive(:all).and_return(condos)

    login_as admin, scope: :admin
    visit root_path

    expect(page).to have_link 'Condomínio Vila das Flores'
    expect(page).to have_content 'São Paulo'
    expect(page).to have_link 'Edifício Monte Verde'
    expect(page).to have_content 'Recife'
    expect(page).to have_link 'Condomínio Lagoa Serena'
    expect(page).to have_content 'Caxias do Sul'
    expect(page).to have_link 'Condomínio Paulista'
    expect(page).to have_content 'São Paulo'
    expect(page).not_to have_link 'Residencial Jardim Europa'
    expect(page).not_to have_link 'Edifício Uruguai'
    expect(page).not_to have_content 'Curitiba'
  end

  it 'e vê todos os condomínios cadastrados' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    condos << Condo.new(id: 2, name: 'Residencial Jardim Europa', city: 'Maceió')
    condos << Condo.new(id: 3, name: 'Edifício Monte Verde', city: 'Recife')
    condos << Condo.new(id: 4, name: 'Condomínio Lagoa Serena', city: 'Caxias do Sul')
    condos << Condo.new(id: 5, name: 'Condomínio Paulista', city: 'São Paulo')
    condos << Condo.new(id: 6, name: 'Edifício Uruguai', city: 'Curitiba')
    allow(Condo).to receive(:all).and_return(condos)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Mostrar todos'

    expect(page).to have_link 'Condomínio Vila das Flores'
    expect(page).to have_content 'São Paulo'
    expect(page).to have_link 'Edifício Monte Verde'
    expect(page).to have_content 'Recife'
    expect(page).to have_link 'Condomínio Lagoa Serena'
    expect(page).to have_content 'Caxias do Sul'
    expect(page).to have_link 'Condomínio Paulista'
    expect(page).to have_content 'São Paulo'
    expect(page).to have_link 'Residencial Jardim Europa'
    expect(page).to have_link 'Edifício Uruguai'
    expect(page).to have_content 'Curitiba'
  end

  it 'e deve estar autenticado' do
    visit condos_path

    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
    expect(current_path).to eq new_admin_session_path
  end

  it 'e não existem condomínios registrados' do
    admin = create(:admin)

    response = double('response', success?: true, body: '[]')
    allow(Faraday).to receive(:get).with('http://127.0.0.1:3000/api/v1/condos').and_return(response)

    login_as admin, scope: :admin
    visit root_path

    expect(page).to have_content 'Não existem condomínios registrados.'
  end
end
