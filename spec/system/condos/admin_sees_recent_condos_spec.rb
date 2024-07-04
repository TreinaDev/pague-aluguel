require 'rails_helper'

describe 'Admin vê lista de condomínios recentes' do
  it 'na home page' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    condos << Condo.new(id: 2, name: 'Residencial Jardim Europa', city: 'Maceió')
    condos << Condo.new(id: 3, name: 'Edifício Monte Verde', city: 'Recife')
    condos << Condo.new(id: 4, name: 'Condomínio Lagoa Serena', city: 'Caxias do Sul')
    allow(Condo).to receive(:all).and_return(condos)

    login_as admin, scope: :admin
    visit root_path

    expect(page).to have_link 'Condomínio Vila das Flores'
    expect(page).to have_content 'São Paulo'
    expect(page).to have_link 'Residencial Jardim Europa'
    expect(page).to have_content 'Maceió'
    expect(page).to have_link 'Edifício Monte Verde'
    expect(page).to have_content 'Recife'
    expect(page).to have_link 'Condomínio Lagoa Serena'
    expect(page).to have_content 'Caxias do Sul'
    expect(current_path).to eq condos_path
  end
end
