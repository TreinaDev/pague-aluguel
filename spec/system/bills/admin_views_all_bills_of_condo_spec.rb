require 'rails_helper'

describe 'Admin vê todos os faturas de um condomínio' do
  it 'a partir da dashboard de admin' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    condos << Condo.new(id: 2, name: 'Residencial Jardim Europa', city: 'Maceió')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 40, description: 'Apartamento Kitnet', ideal_fraction: 0.5, condo_id: 1)
    unit_types << UnitType.new(id: 2, area: 40, description: 'Apartamento 1 quarto', ideal_fraction: 0.5, condo_id: 2)
    units = []
    units << Unit.new(id: 1, area: 40, floor: 1, number: 1, unit_type_id: 1)
    units << Unit.new(id: 2, area: 40, floor: 1, number: 2, unit_type_id: 1)
    units << Unit.new(id: 3, area: 40, floor: 3, number: 1, unit_type_id: 2)
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos[1])
    allow(CommonArea).to receive(:all).and_return([])
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(UnitType).to receive(:find).and_return(unit_types.last)
    allow(Unit).to receive(:find_all_by_condo).and_return(units)

    bills = []
    bills << create(:bill, condo_id: 2, unit_id: units[0].id, due_date: 10.days.from_now, total_value_cents: 500_00)
    bills << create(:bill, condo_id: 2, unit_id: units[1].id, due_date: 10.days.from_now, total_value_cents: 700_00)
    bills << create(:bill, condo_id: 1, unit_id: units[2].id, due_date: 10.days.from_now, total_value_cents: 900_00)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Residencial Jardim Europa'
    within('div#bills_section') do
      click_on 'Ver todas'
    end

    formatted_date = I18n.l(10.days.from_now.to_date)
    expect(page).to have_content 'FATURAS'
    expect(page).to have_content 'Residencial Jardim Europa'.upcase
    expect(page).to have_content 'Unidade 11'
    expect(page).to have_content 'valor total', count: 2
    expect(page).to have_content 'R$500,00'
    expect(page).to have_content 'data de vencimento', count: 2
    expect(page).to have_content formatted_date, count: 2
    expect(page).to have_content 'Unidade 12'
    expect(page).to have_content 'R$700,00'
    expect(page).not_to have_content 'Unidade 31'
    expect(page).not_to have_content 'R$900,00'
  end

  it 'e não há faturas registradas' do
    admin = create(:admin)
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    condos = []
    condos << condo
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condo)
    allow(CommonArea).to receive(:all).and_return([])

    login_as admin, scope: :admin
    visit condo_bills_path(condo_id: condo.id)

    expect(page).to have_content 'Nenhuma fatura encontrada'
  end
end
