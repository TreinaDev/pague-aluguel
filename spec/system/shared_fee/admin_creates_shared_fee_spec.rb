require 'rails_helper'

describe 'Admin lança uma conta compartilhada' do
  it 'com sucesso' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    condominium = Condo.create!(name: 'Condo Test', city: 'City Test')
    unit_type_one = FactoryBot.create(:unit_type, condo: condominium, ideal_fraction: 0.04)
    unit_type_two = FactoryBot.create(:unit_type, condo: condominium, ideal_fraction: 0.06)
    FactoryBot.create_list(:unit, 10, unit_type: unit_type_one)
    FactoryBot.create_list(:unit, 10, unit_type: unit_type_two)

    login_as admin, scope: :admin
    visit root_path
    within('nav') do
      click_on 'Lançar Conta Compartilhada'
    end
    select 'Condo Test', from: 'Condomínio'
    fill_in 'Descrição', with: 'Conta de Luz'
    fill_in 'Data de Emissão', with: 10.days.from_now.to_date
    fill_in 'Valor Total', with: 10_000
    click_on 'Registrar'

    expect(page).to have_content('Conta Compartilhada lançada com sucesso!')
    expect(current_path).to eq(shared_fee_path(SharedFee.last))
    expect(page).to have_content('Condomínio: Condo Test')
    expect(page).to have_content('Descrição: Conta de Luz')
    expect(page).to have_content("Data de Emissão: #{I18n.l(10.days.from_now.to_date)}")
    expect(page).to have_content('Valor Total: R$10.000,00')
  end

  it 'e não está autenticado' do
    FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')

    visit new_shared_fee_path

    expect(page).to have_content('Para continuar, faça login ou registre-se.')
    expect(current_path).to eq new_admin_session_path
  end

  it 'e deve preencher todos os campos' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    condominium = Condo.create!(name: 'Condo Test', city: 'City Test')
    unit_type_one = FactoryBot.create(:unit_type, condo: condominium, ideal_fraction: 0.04)
    unit_type_two = FactoryBot.create(:unit_type, condo: condominium, ideal_fraction: 0.06)
    FactoryBot.create_list(:unit, 10, unit_type: unit_type_one)
    FactoryBot.create_list(:unit, 10, unit_type: unit_type_two)

    login_as admin, scope: :admin
    visit root_path
    within('nav') do
      click_on 'Lançar Conta Compartilhada'
    end
    click_on 'Registrar'

    expect(current_path).to eq(new_shared_fee_path)
    expect(page).to have_content('Não foi possível lançar a conta compartilhada.')
    expect(page).to have_content('Descrição não pode ficar em branco')
    expect(page).to have_content('Data de Emissão não pode ficar em branco')
    expect(page).to have_content('Valor Total não é um número')
  end

  it 'e lança mais de uma conta' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    condominium = Condo.create!(name: 'Condo Test', city: 'City Test')
    unit_type_one = FactoryBot.create(:unit_type, condo: condominium, ideal_fraction: 0.04)
    unit_type_two = FactoryBot.create(:unit_type, condo: condominium, ideal_fraction: 0.06)
    FactoryBot.create_list(:unit, 9, unit_type: unit_type_one)
    FactoryBot.create_list(:unit, 9, unit_type: unit_type_two)
    unit_one = Unit.create!(area: 40, floor: 1, number: 101, unit_type: unit_type_one)
    unit_two = Unit.create!(area: 60, floor: 2, number: 202, unit_type: unit_type_two)
    conta_de_luz = SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                                     total_value: 10_000, condo: condominium)

    login_as admin, scope: :admin
    visit root_path
    within('nav') do
      click_on 'Lançar Conta Compartilhada'
    end
    select 'Condo Test', from: 'Condomínio'
    fill_in 'Descrição', with: 'Conta de Água'
    fill_in 'Data de Emissão', with: 10.days.from_now.to_date
    fill_in 'Valor Total', with: 5_000
    click_on 'Registrar'

    conta_de_luz_fraction_one = unit_one.shared_fee_fractions.find_by(shared_fee: conta_de_luz)
    conta_de_luz_fraction_two = unit_two.shared_fee_fractions.find_by(shared_fee: conta_de_luz)
    conta_de_agua = SharedFee.last
    conta_de_agua_fraction_one = unit_one.shared_fee_fractions.find_by(shared_fee: conta_de_agua)
    conta_de_agua_fraction_two = unit_two.shared_fee_fractions.find_by(shared_fee: conta_de_agua)
    expect(conta_de_luz_fraction_one.value_cents).to eq(400_00)
    expect(conta_de_luz_fraction_two.value_cents).to eq(600_00)
    expect(Money.new(conta_de_luz_fraction_one.value_cents, 'BRL').format).to eq('R$400,00')
    expect(Money.new(conta_de_luz_fraction_two.value_cents, 'BRL').format).to eq('R$600,00')
    expect(conta_de_agua_fraction_one.value_cents).to eq(200_00)
    expect(conta_de_agua_fraction_two.value_cents).to eq(300_00)
    expect(Money.new(conta_de_agua_fraction_one.value_cents, 'BRL').format).to eq('R$200,00')
    expect(Money.new(conta_de_agua_fraction_two.value_cents, 'BRL').format).to eq('R$300,00')
    expect(conta_de_luz.description).to eq('Conta de Luz')
    expect(conta_de_luz.issue_date).to eq(10.days.from_now.to_date)
    expect(conta_de_agua.description).to eq('Conta de Água')
    expect(conta_de_agua.issue_date).to eq(10.days.from_now.to_date)
  end
end
