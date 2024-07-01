require 'rails_helper'

describe 'Administrador acessa página do condomínio' do
  it 'com sucesso' do
    admin = create(:admin)
    Condo.create!(name: 'Condomínio Vila das Flores', city: 'São Paulo')
    Condo.create!(name: 'Residencial Jardim Europa', city: 'Maceió')
    Condo.create!(name: 'Edifício Monte Verde', city: 'Recife')
    Condo.create!(name: 'Condomínio Lagoa Serena', city: 'Caxias do Sul')

    login_as admin, scope: :admin
    visit root_path
    click_on 'Lista de Condomínios'
    click_on 'Edifício Monte Verde'

    expect(page).to have_content('Condomínio: Edifício Monte Verde')
    expect(page).to have_content('Cidade: Recife')
  end

  it 'e clica em Gerenciar Condomínio' do
    admin = create(:admin)
    Condo.create!(name: 'Condomínio Vila das Flores', city: 'São Paulo')
    Condo.create!(name: 'Residencial Jardim Europa', city: 'Maceió')
    Condo.create!(name: 'Edifício Monte Verde', city: 'Recife')
    Condo.create!(name: 'Condomínio Lagoa Serena', city: 'Caxias do Sul')

    login_as admin, scope: :admin
    visit root_path
    click_on 'Lista de Condomínios'
    click_on 'Edifício Monte Verde'
    click_on 'Gerenciar Condomínio'

    expect(page).to have_link('Lançar Conta Compartilhada')
  end
end
