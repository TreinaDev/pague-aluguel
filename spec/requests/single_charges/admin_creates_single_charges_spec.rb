require 'rails_helper'

describe 'Admin cria uma cobrança avulsa' do
  it 'com sucesso - super admin' do
    admin = create(:admin, super_admin: true)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    units = []
    units << Unit.new(id: 1, area: 40, floor: 1, number: '31', unit_type_id: 1)
    units << Unit.new(id: 2, area: 40, floor: 1, number: '11', unit_type_id: 1)
    common_areas = []
    common_areas << CommonArea.new(id: 1, name: 'Churrasqueira',
                                   description: 'Área gourmet pra assar carne e batata assada',
                                   max_occupancy: 20, rules: 'Não pode ser vegano', condo_id: 1)
    allow(Condo).to receive(:find).and_return(condo)
    allow(Unit).to receive(:all).and_return(units)
    allow(Unit).to receive(:find).and_return(units.first)
    allow(CommonArea).to receive(:all).and_return(common_areas)

    login_as admin, scope: :admin
    post(condo_single_charges_path(condo.id),
         params: { single_charge: { unit_id: 1, value: 100,
                                    issue_date: 5.days.from_now.to_date,
                                    description: 'Cobrança',
                                    charge_type: 'fine',
                                    condo_id: 1,
                                    common_area_id: nil } })

    single_charge = SingleCharge.first
    expect(single_charge.value_cents).to eq 100_00
    expect(single_charge.description).to eq 'Cobrança'
    expect(response).to redirect_to condo_path(condo.id)
  end

  it 'com sucesso - admin associado' do
    admin = create(:admin, super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    units = []
    units << Unit.new(id: 1, area: 40, floor: 1, number: '31', unit_type_id: 1)
    units << Unit.new(id: 2, area: 40, floor: 1, number: '11', unit_type_id: 1)
    common_areas = []
    common_areas << CommonArea.new(id: 1, name: 'Churrasqueira',
                                   description: 'Área gourmet pra assar carne e batata assada',
                                   max_occupancy: 20, rules: 'Não pode ser vegano', condo_id: 1)
    allow(Condo).to receive(:find).and_return(condo)
    allow(Unit).to receive(:all).and_return(units)
    allow(Unit).to receive(:find).and_return(units.first)
    allow(CommonArea).to receive(:all).and_return(common_areas)
    AssociatedCondo.create!(admin:, condo_id: condo.id)

    login_as admin, scope: :admin
    post(condo_single_charges_path(condo.id),
         params: { single_charge: { unit_id: 1, value: 100,
                                    issue_date: 5.days.from_now.to_date,
                                    description: 'Cobrança',
                                    charge_type: 'fine',
                                    condo_id: 1,
                                    common_area_id: nil } })

    single_charge = SingleCharge.first
    expect(single_charge.value_cents).to eq 100_00
    expect(single_charge.description).to eq 'Cobrança'
    expect(response).to redirect_to condo_path(condo.id)
  end

  it 'falha por nao estar associado' do
    admin = create(:admin, super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    common_areas = []
    common_areas << CommonArea.new(id: 1, name: 'Churrasqueira',
                                   description: 'Área gourmet pra assar carne e batata assada',
                                   max_occupancy: 20, rules: 'Não pode ser vegano', condo_id: 1)
    allow(Condo).to receive(:find).and_return(condo)
    allow(CommonArea).to receive(:all).and_return(common_areas)

    login_as admin, scope: :admin
    post(condo_single_charges_path(condo.id),
         params: { single_charge: { unit_id: 1, value: 100,
                                    issue_date: 5.days.from_now.to_date,
                                    description: 'Cobrança',
                                    charge_type: 'fine',
                                    condo_id: 1,
                                    common_area_id: nil } })

    expect(response).to have_http_status :found
    expect(response).to redirect_to root_path
    expect(flash[:notice]).to eq 'Você não tem autorização para completar esta ação.'
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
end
