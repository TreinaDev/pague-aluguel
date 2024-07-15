require 'rails_helper'

describe 'Admin visualiza listagem de cobranças avulsas' do
  it 'navegando a partir do root_path' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    condos << Condo.new(id: 2, name: 'Condo Dois', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 40, description: 'Apartamento 1 quarto', ideal_fraction: 0.3, condo_id: 1)
    unit_types << UnitType.new(id: 2, area: 40, description: 'Apartamento 2 quarto', ideal_fraction: 0.7, condo_id: 2)
    units = []
    units << Unit.new(id: 1, area: 40, floor: 1, number: 1, unit_type_id: 1)
    units << Unit.new(id: 2, area: 40, floor: 1, number: 2, unit_type_id: 1)
    units << Unit.new(id: 3, area: 40, floor: 1, number: 3, unit_type_id: 2)
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(UnitType).to receive(:find).with(1).and_return(unit_types.first)
    allow(UnitType).to receive(:find).with(2).and_return(unit_types.last)
    allow(Unit).to receive(:all).and_return(units)
    allow(Unit).to receive(:find).with(1).and_return(units.first)
    allow(Unit).to receive(:find).with(2).and_return(units.second)
    allow(Unit).to receive(:find).with(3).and_return(units.last)
    allow(CommonArea).to receive(:all).and_return([])
    create(:single_charge, charge_type: 'fine', unit_id: 1)
    create(:single_charge, charge_type: 'fine', unit_id: 3, condo_id: 2)
    create(:single_charge, charge_type: 'other', unit_id: 2)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Condo Test'
    within '#single-charge' do
      click_on 'Ver todas'
    end

    expect(current_path).to eq condo_single_charges_path(condos.first.id)
    expect(page).not_to have_content 'Não foram encontradas cobranças avulsas.'
    expect(page).to have_content 'Outros'
    expect(page).to have_content 'Unidade 11'
    expect(page).to have_content 'Unidade 12'
    expect(page).to have_link 'Outros', href: condo_single_charge_path(condos.first.id, SingleCharge.last.id)
    expect(page).to have_link 'Multa', href: condo_single_charge_path(condos.first.id, SingleCharge.first.id)
    expect(page).not_to have_link 'Multa', href: condo_single_charge_path(condos.last.id, SingleCharge.second.id)
    expect(page).not_to have_content 'Unidade 13'
  end

  it 'e não há cobranças' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 40, description: 'Apartamento 1 quarto', ideal_fraction: 0.5, condo_id: 1)
    units = []
    units << Unit.new(id: 1, area: 40, floor: 1, number: 1, unit_type_id: 1)
    units << Unit.new(id: 2, area: 40, floor: 1, number: 1, unit_type_id: 1)
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(Unit).to receive(:all).and_return(units)
    allow(CommonArea).to receive(:all).and_return([])

    login_as admin, scope: :admin
    visit root_path
    click_on 'Condo Test'
    within '#single-charge' do
      click_on 'Ver todas'
    end

    expect(page).to have_content 'Não foram encontradas cobranças avulsas.'
  end
end
