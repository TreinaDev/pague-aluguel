require 'rails_helper'

describe 'Admin lança uma conta compartilhada' do
  it 'com sucesso' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.04,
                               condo_id: 1)
    unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.06,
                               condo_id: 1)
    units = []
    units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)

    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(Unit).to receive(:all).and_return(units)
    allow(CommonArea).to receive(:all).and_return([])

    login_as admin, scope: :admin
    visit root_path
    click_on 'Condo Test'
    within 'div#shared-fee' do
      click_on 'Adicionar nova'
    end
    fill_in 'Descrição', with: 'Conta de Luz'
    fill_in 'Data de Emissão', with: 10.days.from_now.to_date
    fill_in 'Valor Total', with: 10_000
    click_on 'Cadastrar'

    expect(page).to have_content 'Conta Compartilhada lançada com sucesso!'
    expect(current_path).to eq condo_path(condos.first.id)
    expect(page).to have_content 'Condo Test'
    expect(page).to have_content 'Conta de Luz'
    expect(page).to have_content 'valor total'
    expect(page).to have_content 'R$10.000,00'
  end

  it 'e não está autenticado' do
    FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:find).and_return(condo)
    allow(CommonArea).to receive(:all).and_return([])

    visit new_condo_shared_fee_path(condo.id)

    expect(page).to have_content('Para continuar, faça login ou registre-se.')
    expect(current_path).to eq new_admin_session_path
  end

  it 'e deve preencher todos os campos' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.04,
                               condo_id: 1)
    unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.06,
                               condo_id: 1)
    units = []
    units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)

    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(Unit).to receive(:all).and_return(units)
    allow(CommonArea).to receive(:all).and_return([])

    login_as admin, scope: :admin
    visit root_path
    click_on 'Condo Test'
    within 'div#shared-fee' do
      click_on 'Adicionar nova'
    end
    click_on 'Cadastrar'

    expect(current_path).to eq(new_condo_shared_fee_path(condos.first.id))
    expect(page).to have_content 'Não foi possível lançar a conta compartilhada.'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Data de Emissão não pode ficar em branco'
    expect(page).to have_content 'Valor Total não é um número'
  end

  it 'e retorna para a tela de condomínio' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(CommonArea).to receive(:all).and_return([])

    login_as admin, scope: :admin
    visit root_path
    click_on 'Condo Test'
    within 'div#shared-fee' do
      click_on 'Adicionar nova'
    end
    find('#arrow-left').click

    expect(current_path).to eq condo_path(condos.first.id)
  end

  it 'e lança mais de uma conta' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.04,
                               condo_id: 1)
    unit_types << UnitType.new(id: 2, area: 30, description: 'Apartamento 2 quarto', ideal_fraction: 0.06,
                               condo_id: 1)
    units = []
    units << Unit.new(id: 1, area: 40, floor: 1, number: 101, unit_type_id: 1)
    units << Unit.new(id: 2, area: 60, floor: 2, number: 202, unit_type_id: 2)

    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(Unit).to receive(:all).and_return(units)
    allow(CommonArea).to receive(:all).and_return([])

    conta_de_luz = SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                                     total_value: 10_000, condo_id: condos.first.id)
    conta_de_luz.calculate_fractions

    login_as admin, scope: :admin
    visit root_path
    click_on 'Condo Test'
    within 'div#shared-fee' do
      click_on 'Adicionar nova'
    end
    fill_in 'Descrição', with: 'Conta de Água'
    fill_in 'Data de Emissão', with: 10.days.from_now.to_date
    fill_in 'Valor Total', with: 5_000
    click_on 'Cadastrar'

    conta_de_luz_fraction_one = SharedFeeFraction.find_by(unit_id: units[0], shared_fee: conta_de_luz)
    conta_de_luz_fraction_two = SharedFeeFraction.find_by(unit_id: units[1], shared_fee: conta_de_luz)
    conta_de_agua = SharedFee.last
    conta_de_agua_fraction_one = SharedFeeFraction.find_by(unit_id: units[0], shared_fee: conta_de_agua)
    conta_de_agua_fraction_two = SharedFeeFraction.find_by(unit_id: units[1], shared_fee: conta_de_agua)

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
