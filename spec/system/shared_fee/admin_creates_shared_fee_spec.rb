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

  it 'and successfully creates a shared fee issue' do
    admin = Admin.create!(email: 'admin@email.com', password: '123456')
    condo = Condo.create!(name: 'Condo Test', city: 'City Test')
    unit_type = FactoryBot.create(:unit_type, condo:, ideal_fraction: 0.04)
    unit_type2 = FactoryBot.create(:unit_type, condo:, ideal_fraction: 0.06)
    FactoryBot.create_list(:unit, 10, unit_type:)
    FactoryBot.create_list(:unit, 10, unit_type: unit_type2)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Lançar Conta Compartilhada'
    select 'Condo Test', from: 'Condomínio'
    fill_in 'Descrição', with: 'Conta de Luz'
    fill_in 'Data de Emissão', with: 10.days.from_now
    fill_in 'Valor Total', with: 10_000
    click_on 'Registrar'

    expect(page).to have_content('Conta Compartilhada lançada com sucesso!')
    expect(current_path).to eq(shared_fee_path(SharedFee.last))
    expect(page).to have_content('Condomínio: Condo Test')
    expect(page).to have_content('Descrição: Conta de Luz')
    expect(page).to have_content("Data de Emissão: #{10.days.from_now}")
    expect(page).to have_content('Valor Total: R$ 10.000,00')
  end
end
