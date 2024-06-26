require 'rails_helper'

describe 'Admin tries to create a shared fee' do
  it 'and successfully creates a shared fee issue' do
    admin = Admin.create!(email: 'admin@email.com', password: '123456')
    condominio = Condo.create!(name: 'Condo Test', city: 'City Test')
    unit_type_one = FactoryBot.create(:unit_type, condo: condominio, ideal_fraction: 0.04)
    unit_type_two = FactoryBot.create(:unit_type, condo: condominio, ideal_fraction: 0.06)
    FactoryBot.create_list(:unit, 10, unit_type: unit_type_one)
    FactoryBot.create_list(:unit, 10, unit_type: unit_type_two)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Lançar Conta Compartilhada'
    select 'Condo Test', from: 'Condomínio'
    fill_in 'Descrição', with: 'Conta de Luz'
    fill_in 'Data de Emissão', with: 10.days.from_now.to_date
    fill_in 'Valor Total', with: 10_000
    click_on 'Registrar'

    expect(page).to have_content('Conta Compartilhada lançada com sucesso!')
    expect(current_path).to eq(shared_fee_path(SharedFee.last))
    expect(page).to have_content('Condomínio: Condo Test')
    expect(page).to have_content('Descrição: Conta de Luz')
    expect(page).to have_content("Data de Emissão: #{10.days.from_now.to_date}")
    expect(page).to have_content('Valor Total: R$ 10000')
  end

  it 'and is not authenticated' do
    Admin.create!(email: 'admin@email.com', password: '123456')

    visit new_shared_fee_path

    expect(page).to have_content('Para continuar, faça login ou registre-se.')
    expect(current_path).to eq new_admin_session_path
  end

  it 'and must fill in all form fields' do
    admin = Admin.create!(email: 'admin@email.com', password: '123456')
    condominio = Condo.create!(name: 'Condo Test', city: 'City Test')
    unit_type_one = FactoryBot.create(:unit_type, condo: condominio, ideal_fraction: 0.04)
    unit_type_two = FactoryBot.create(:unit_type, condo: condominio, ideal_fraction: 0.06)
    FactoryBot.create_list(:unit, 10, unit_type: unit_type_one)
    FactoryBot.create_list(:unit, 10, unit_type: unit_type_two)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Lançar Conta Compartilhada'
    click_on 'Registrar'

    expect(current_path).to eq(new_shared_fee_path)
    expect(page).to have_content('Não foi possível lançar a conta compartilhada.')
    expect(page).to have_content('Descrição não pode ficar em branco')
    expect(page).to have_content('Data de Emissão não pode ficar em branco')
    expect(page).to have_content('Valor Total não pode ficar em branco')
  end
end
