require 'rails_helper'

describe 'Admin access a list of all registered condos' do
  it 'successfully' do
    admin = create(:admin)
    Condo.create!(name: 'Condomínio Vila das Flores', city: 'São Paulo')
    Condo.create!(name: 'Residencial Jardim Europa', city: 'Maceió')
    Condo.create!(name: 'Edifício Monte Verde', city: 'Recife')
    Condo.create!(name: 'Condomínio Lagoa Serena', city: 'Caxias do Sul')

    login_as admin, scope: :admin
    visit root_path
    click_on 'Lista de Condomínios'

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

  it 'and must be authenticated' do
    create(:condo)

    visit condos_path

    expect(page).to have_content('Para continuar, faça login ou registre-se.')
    expect(current_path).to eq new_admin_session_path
  end
end
