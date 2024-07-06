require 'rails_helper'

describe 'Admin cancela uma conta compartilhada' do
  it 'a partir da tela de detalhes de uma conta compartilhada' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.4, condo_id: 1)
    unit_types << UnitType.new(id: 2, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.6, condo_id: 1)
    units = []
    units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
    units << Unit.new(id: 2, area: 100, floor: 1, number: 1, unit_type_id: 2)
    SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                      total_value: 10_000, condo_id: condos.first.id)
    allow(Unit).to receive(:all).and_return(units)
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(UnitType).to receive(:all).and_return(unit_types)

    login_as admin, scope: :admin
    visit condo_path(condos.first.id)
    within 'div#shared-fee' do
      click_on 'Ver todas'
    end
    click_on 'Conta de Luz'
    click_on 'Cancelar'
    bill = SharedFee.last

    expect(page).to have_content "#{bill.description} cancelada com sucesso"
    expect(bill.active?).to eq false
    expect(bill.canceled?).to eq true
    expect(current_path).to eq condo_shared_fees_path(condos.first.id)
    expect(page).to have_content 'CANCELADA'
  end

  it 'e não vê mais o botão de cancelar' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.4, condo_id: 1)
    unit_types << UnitType.new(id: 2, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.6, condo_id: 1)
    units = []
    units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
    units << Unit.new(id: 2, area: 100, floor: 1, number: 1, unit_type_id: 2)
    SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                      total_value: 10_000, condo_id: condos.first.id)
    allow(Unit).to receive(:all).and_return(units)
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(UnitType).to receive(:all).and_return(unit_types)

    login_as admin, scope: :admin
    visit condo_path(condos.first.id)
    within 'div#shared-fee' do
      click_on 'Ver todas'
    end
    click_on 'Conta de Luz'
    click_on 'Cancelar'
    click_on 'Conta de Luz'

    expect(page).to have_content ''
    expect(page).not_to have_button 'Cancelar'
  end

  it 'e as frações são removidas das unidades' do
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
    electric_bill = SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                                      total_value: 10_000, condo_id: condos.first.id)
    electric_bill.calculate_fractions
    water_bill = SharedFee.create!(description: 'Conta de Água', issue_date: 10.days.from_now.to_date,
                                   total_value: 5_000, condo_id: condos.first.id)
    water_bill.calculate_fractions

    login_as admin, scope: :admin
    visit condo_path(condos.first.id)
    within 'div#shared-fee' do
      click_on 'Ver todas'
    end
    click_on 'Conta de Luz'
    click_on 'Cancelar'
    electric_bill.reload
    water_bill.reload

    expect(SharedFeeFraction.find_by(unit_id: units[0], shared_fee: electric_bill).status).to eq 'canceled'
    expect(SharedFeeFraction.find_by(unit_id: units[0], shared_fee: water_bill).status).to eq 'active'
  end
end
