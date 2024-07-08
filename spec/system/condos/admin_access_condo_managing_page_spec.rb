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
    click_on 'Edifício Monte Verde'

    expect(page).to have_content 'Condomínios'
    expect(page).to have_content 'Condomínio'
    expect(page).to have_content 'Edifício Monte Verde'
    expect(page).to have_content 'Recife'
    expect(page).to have_content 'Contas Compartilhadas'
    expect(page).to have_content 'Taxas'
    expect(page).to have_content 'Áreas Comuns'
  end

  it 'e vê dashboard do admin' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    condos << Condo.new(id: 2, name: 'Residencial Jardim Europa', city: 'Maceió')
    condos << condo = Condo.new(id: 3, name: 'Edifício Monte Verde', city: 'Recife')
    condos << Condo.new(id: 4, name: 'Condomínio Lagoa Serena', city: 'Caxias do Sul')
    create(:common_area, name: 'Salão de Festas', condo_id: condo.id)
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos[2])

    login_as admin, scope: :admin
    visit root_path
    click_on 'Edifício Monte Verde'

    within 'div#shared-fee' do
      expect(page).to have_link 'Adicionar nova'
    end
    within 'div#base-fee' do
      expect(page).to have_link 'Adicionar nova'
    end
    within 'div#common-areas' do
      expect(page).to have_link 'Salão de Festas'
    end
  end
end
