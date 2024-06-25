require 'rails_helper'

describe 'Admin tries to create a shared fee' do
  it 'and successfully views form for shared fee issue' do
    admin = Admin.create!(email: 'admin@email.com', password: '123456')

    login_as admin, scope: :admin
    visit root_path
    click_on 'Lançar Conta Compartilhada'

    expect(current_path).to eq new_shared_fee_path
    expect(page).to have_field 'Condomínio'
    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'Data de Emissão'
    expect(page).to have_field 'Valor Total'
    expect(page).to have_button 'Registrar'
  end
end
