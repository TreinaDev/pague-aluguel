require 'rails_helper'

describe 'Admin cancela uma conta compartilhada' do
  it 'a partir da tela de detalhes de uma conta compartilhada' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                               unit_ids: [1])
    unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quartos', metreage: 200, fraction: 2.0,
                               unit_ids: [2])
    units = []
    units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
    units << Unit.new(id: 2, area: 100, floor: 1, number: 1, unit_type_id: 2)
    SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                      total_value: 10_000, condo_id: condos.first.id)
    allow(Unit).to receive(:all).and_return(units)
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(CommonArea).to receive(:all).and_return([])

    login_as admin, scope: :admin
    visit condo_path(condos.first.id)
    within 'div#shared-fee' do
      click_on 'Ver todas'
    end
    click_on 'Conta de Luz'
    accept_confirm 'Tem certeza que deseja desativar a taxa? Essa ação não poderá ser desfeita.' do
      click_button 'Cancelar'
    end

    fee = SharedFee.last
    expect(page).to have_content "#{fee.description} cancelada com sucesso"
    expect(fee.active?).to eq false
    expect(fee.canceled?).to eq true
    expect(current_path).to eq condo_shared_fees_path(condos.first.id)
    expect(page).to have_content 'CANCELADA'
  end

  it 'e não vê mais o botão de cancelar' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                               unit_ids: [1])
    unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quartos', metreage: 200, fraction: 2.0,
                               unit_ids: [2])
    units = []
    units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
    units << Unit.new(id: 2, area: 100, floor: 1, number: 1, unit_type_id: 2)
    SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                      total_value: 10_000, condo_id: condos.first.id)
    allow(Unit).to receive(:all).and_return(units)
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(CommonArea).to receive(:all).and_return([])

    login_as admin, scope: :admin
    visit condo_path(condos.first.id)
    within 'div#shared-fee' do
      click_on 'Ver todas'
    end
    click_on 'Conta de Luz'
    accept_confirm 'Tem certeza que deseja desativar a taxa? Essa ação não poderá ser desfeita.' do
      click_button 'Cancelar'
    end
    click_on 'Conta de Luz'

    expect(page).to have_content 'CANCELADA'
    expect(page).not_to have_button 'Cancelar'
  end

  it 'e as frações são removidas das unidades' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                               unit_ids: [1])
    unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quartos', metreage: 200, fraction: 2.0,
                               unit_ids: [2])
    units = []
    units << Unit.new(id: 1, area: 40, floor: 1, number: 101, unit_type_id: 1)
    units << Unit.new(id: 2, area: 60, floor: 2, number: 202, unit_type_id: 2)
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(Unit).to receive(:all).and_return(units)
    allow(CommonArea).to receive(:all).and_return([])
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
    accept_confirm 'Tem certeza que deseja desativar a taxa? Essa ação não poderá ser desfeita.' do
      click_button 'Cancelar'
    end
    electric_bill.reload
    water_bill.reload

    expect(SharedFeeFraction.find_by(unit_id: units[0], shared_fee: electric_bill).status).to eq 'canceled'
    expect(SharedFeeFraction.find_by(unit_id: units[0], shared_fee: water_bill).status).to eq 'active'
  end
end
