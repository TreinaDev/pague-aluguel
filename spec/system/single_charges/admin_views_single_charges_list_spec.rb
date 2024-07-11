require 'rails_helper'

describe 'Admin visualiza listagem de cobranças avulsas' do
  it 'navegando a partir do root_path' do
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
    create(:single_charge, charge_type: 'fine')
    create(:single_charge, charge_type: 'fine', condo_id: 2)
    create(:single_charge, charge_type: 'other')

    login_as admin, scope: :admin
    visit root_path
    click_on 'Condo Test'
    within '#single-charge' do
      click_on 'Ver todas'
    end

    expect(current_path).to eq condo_single_charges_path(condos.first.id)
    expect(page).not_to have_content 'Não foram encontradas cobranças avulsas.'
    expect(page).to have_content 'Outros'
    expect(page).to have_link 'Outros', href: condo_single_charge_path(condos.first.id, SingleCharge.last.id)
    expect(page).to have_link 'Multa', href: condo_single_charge_path(condos.first.id, SingleCharge.first.id)
    expect(page).not_to have_link 'Multa', href: condo_single_charge_path(condos.last.id, SingleCharge.second.id)
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
