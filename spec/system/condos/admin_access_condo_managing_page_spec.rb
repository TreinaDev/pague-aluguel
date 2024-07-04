require 'rails_helper'

describe 'Administrador acessa página do condomínio' do
  it 'com sucesso' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    condos << Condo.new(id: 2, name: 'Residencial Jardim Europa', city: 'Maceió')
    condos << Condo.new(id: 3, name: 'Edifício Monte Verde', city: 'Recife')
    condos << Condo.new(id: 4, name: 'Condomínio Lagoa Serena', city: 'Caxias do Sul')
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos[2])

    login_as admin, scope: :admin
    visit root_path
    click_on 'Lista de Condomínios'
    click_on 'Edifício Monte Verde'

    expect(page).to have_content 'Condomínio: Edifício Monte Verde'
    expect(page).to have_content 'Cidade: Recife'
  end

  it 'e clica em Gerenciar Condomínio' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    condos << Condo.new(id: 2, name: 'Residencial Jardim Europa', city: 'Maceió')
    condos << Condo.new(id: 3, name: 'Edifício Monte Verde', city: 'Recife')
    condos << Condo.new(id: 4, name: 'Condomínio Lagoa Serena', city: 'Caxias do Sul')
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos[2])

    login_as admin, scope: :admin
    visit root_path
    click_on 'Lista de Condomínios'
    click_on 'Edifício Monte Verde'
    click_on 'Gerenciar Condomínio'

    expect(page).to have_link 'Lançar Conta Compartilhada'
  end
end
