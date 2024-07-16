require 'rails_helper'

describe 'Admin vê detalhes de uma fatura' do
  it 'a partir da tela de listagem de faturas' do
    admin = create(:admin)
    condos = []
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    condos << condo
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 40, description: 'Apartamento Kitnet', ideal_fraction: 0.5, condo_id: 1)
    units = []
    units << Unit.new(id: 1, area: 40, floor: 1, number: 1, unit_type_id: 1)
    units << Unit.new(id: 2, area: 40, floor: 1, number: 2, unit_type_id: 1)
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condo)
    allow(CommonArea).to receive(:all).and_return([])
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(UnitType).to receive(:find).and_return(unit_types.first)
    allow(Unit).to receive(:find_all_by_condo).and_return(units)
    allow(Unit).to receive(:find).with(1).and_return(units.first)
    allow(Unit).to receive(:find).with(2).and_return(units.second)

    bills = []
    bills << create(:bill, condo_id: 1, unit_id: units[0].id, issue_date: Time.zone.today.beginning_of_month,
                           due_date: 10.days.from_now, total_value_cents: 500_00)
    bills << create(:bill, condo_id: 1, unit_id: units[1].id, issue_date: Time.zone.today.beginning_of_month,
                           due_date: 10.days.from_now, total_value_cents: 700_00)

    login_as admin, scope: :admin
    visit condo_bills_path(condo_id: condo.id)
    click_on 'Unidade 12'

    formatted_issue_date = I18n.l(Time.zone.today.beginning_of_month)
    formatted_due_date = I18n.l(10.days.from_now.to_date)
    expect(page).to have_content 'Fatura'
    expect(page).to have_content 'Unidade 12'
    expect(page).to have_content 'data de emissão'
    expect(page).to have_content formatted_issue_date
    expect(page).to have_content 'data de vencimento'
    expect(page).to have_content formatted_due_date
    expect(page).to have_content 'valor total'
    expect(page).to have_content 'R$700,00'
  end
end
