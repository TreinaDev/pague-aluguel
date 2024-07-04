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
    expect(page).to have_content("Data de Emissão: #{I18n.l(10.days.from_now.to_date)}")
    expect(page).to have_content('Valor Total: R$10.000,00')
    expect(page).to have_content('Situação: Ativa')
  end

  it 'e não está autenticado' do
    FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')

    visit new_shared_fee_path

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

    login_as admin, scope: :admin
    visit root_path
    click_on 'Lançar Conta Compartilhada'
    click_on 'Registrar'

    expect(current_path).to eq(new_shared_fee_path)
    expect(page).to have_content('Não foi possível lançar a conta compartilhada.')
    expect(page).to have_content('Descrição não pode ficar em branco')
    expect(page).to have_content('Data de Emissão não pode ficar em branco')
    expect(page).to have_content('Valor Total não é um número')
  end

  it 'e clica em Voltar para a listagem' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')

    login_as admin, scope: :admin
    visit shared_fees_path(condo_id: condo.id)
    click_on 'Lançar Conta Compartilhada'
    click_on 'Voltar'

    expect(current_path).to eq shared_fees_path
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

    conta_de_luz = SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                                     total_value: 10_000, condo_id: condos.first.id)
    conta_de_luz.calculate_fractions

    login_as admin, scope: :admin
    visit root_path
    click_on 'Lançar Conta Compartilhada'
    select 'Condo Test', from: 'Condomínio'
    fill_in 'Descrição', with: 'Conta de Água'
    fill_in 'Data de Emissão', with: 10.days.from_now.to_date
    fill_in 'Valor Total', with: 5_000
    click_on 'Registrar'

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
