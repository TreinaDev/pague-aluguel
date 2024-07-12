require 'rails_helper'

describe 'Usuário cria uma cobrança avulsa' do
  it 'com sucesso' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 40, description: 'Apartamento 1 quarto', ideal_fraction: 0.5, condo_id: 1)
    units = []
    units << Unit.new(id: 1, area: 40, floor: 1, number: 1, unit_type_id: 1)
    units << Unit.new(id: 2, area: 40, floor: 1, number: 1, unit_type_id: 1)
    common_areas = []
    common_areas << CommonArea.new(id: 1, name: 'Churrasqueira',
                                   description: 'Área gourmet pra assar carne e batata assada',
                                   max_occupancy: 20, rules: 'Não pode ser vegano', condo_id: 1)
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(UnitType).to receive(:find).with(1).and_return(unit_types.first)
    allow(Unit).to receive(:all).and_return(units)
    allow(CommonArea).to receive(:all).and_return(common_areas)

    login_as admin, scope: :admin
    post(condo_single_charges_path(condos.first.id),
         params: { single_charge: { unit_id: 1, value: 100,
                                    issue_date: 5.days.from_now.to_date,
                                    description: 'Cobrança',
                                    charge_type: 'fine',
                                    condo_id: 1,
                                    common_area_id: nil } })

    expect(SingleCharge.last).not_to eq nil
    expect(response).to redirect_to condo_single_charge_path(condos.first.id, SingleCharge.last.id)
  end

  it 'sem autorização' do
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')

    post condo_single_charges_path(condo.id), params: { single_charge: { unit_id: 1,
                                                                         value: 5000,
                                                                         issue_date: 5.days.from_now.to_date,
                                                                         description: 'Detalhes de uma cobrança avulsa',
                                                                         charge_type: 'fine',
                                                                         condo_id: 1,
                                                                         common_area_id: nil } }

    expect(response).to redirect_to new_admin_session_path
  end

  it 'e a unidade não pertence ao condomínio' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    condos << Condo.new(id: 2, name: 'Condo Test 2', city: 'City Test 2')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 40, description: 'Apartamento 1 quarto', ideal_fraction: 1, condo_id: 1)
    unit_types << UnitType.new(id: 2, area: 60, description: 'Apartamento 2 quartos', ideal_fraction: 1, condo_id: 2)
    units = []
    units << Unit.new(id: 1, area: 40, floor: 1, number: 1, unit_type_id: 1)
    units << Unit.new(id: 2, area: 40, floor: 1, number: 1, unit_type_id: 2)
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(UnitType).to receive(:find).with(1).and_return(unit_types.first)
    allow(UnitType).to receive(:find).with(2).and_return(unit_types.last)
    allow(Unit).to receive(:all).and_return(units)
    allow(CommonArea).to receive(:all).and_return([])

    login_as admin, scope: :admin
    post(condo_single_charges_path(condos.first.id),
         params: { single_charge: { unit_id: 2, value: 100,
                                    issue_date: 5.days.from_now.to_date,
                                    description: 'Cobrança',
                                    charge_type: 'fine',
                                    condo_id: 1,
                                    common_area_id: nil } })

    expect(SingleCharge.last).to eq nil
    expect(response).to have_http_status 422
    expect(response).to have_http_status :unprocessable_entity
  end
end
