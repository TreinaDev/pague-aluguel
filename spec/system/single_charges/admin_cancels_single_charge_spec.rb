require 'rails_helper'

describe 'Admin cancela uma cobrança avulsa' do
  it 'a partir da tela de detalhes de uma cobrança avulsa' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 40, description: 'Apartamento 1 quarto', ideal_fraction: 0.3, condo_id: 1)
    units = []
    units << Unit.new(id: 1, area: 40, floor: 1, number: 1, unit_type_id: 1)
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(Unit).to receive(:all).and_return(units)
    allow(Unit).to receive(:find).with(1).and_return(units.first)
    allow(CommonArea).to receive(:all).and_return([])
    create(:single_charge, charge_type: 'fine', unit_id: 1)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Condo Test'
    within '#single-charge' do
      click_on 'Ver todas'
    end
    click_on 'Multa'
    accept_confirm 'Tem certeza que deseja cancelar esse item? Essa ação não poderá ser desfeita.' do
      click_button 'Cancelar'
    end
    single_charge = SingleCharge.last

    expect(page).to have_content "#{single_charge.charge_type} cancelada com sucesso"
    expect(single_charge.active?).to eq false
    expect(single_charge.canceled?).to eq true
    expect(current_path).to eq condo_single_charges_path(condos.first.id)
    expect(page).to have_content 'CANCELADA'
  end

  it 'e não vê mais o botão de cancelar' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 40, description: 'Apartamento 1 quarto', ideal_fraction: 0.3, condo_id: 1)
    units = []
    units << Unit.new(id: 1, area: 40, floor: 1, number: 1, unit_type_id: 1)
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(Unit).to receive(:all).and_return(units)
    allow(Unit).to receive(:find).with(1).and_return(units.first)
    allow(CommonArea).to receive(:all).and_return([])
    create(:single_charge, charge_type: 'fine', unit_id: 1)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Condo Test'
    within '#single-charge' do
      click_on 'Ver todas'
    end
    click_on 'Multa'
    accept_confirm 'Tem certeza que deseja cancelar esse item? Essa ação não poderá ser desfeita.' do
      click_button 'Cancelar'
    end
    click_on 'Multa'

    expect(page).to have_content 'CANCELADA'
    expect(page).not_to have_button 'Cancelar'
  end
end
