require 'rails_helper'

describe 'Admin cria taxa condominial' do
  it 'com sucesso - super admin' do
    admin = create(:admin, email: 'admin@email.com', password: '123456', super_admin: true)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                               unit_ids: [])
    unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quarto', metreage: 200, fraction: 2.0,
                               unit_ids: [])

    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return(unit_types)

    login_as admin, scope: :admin
    post(condo_base_fees_path(condo.id), params: { base_fee: { name: 'Nome',
                                                               description: 'Descrição',
                                                               interest_rate: 2,
                                                               late_fine: 30,
                                                               charge_day: 10.days.from_now,
                                                               condo_id: condo.id,
                                                               values_attributes: {
                                                                 '0': {
                                                                   price: 100,
                                                                   unit_type_id: unit_types.first.id
                                                                 },
                                                                 '1': {
                                                                   price: 100,
                                                                   unit_type_id: unit_types.last.id
                                                                 }
                                                               } } })

    expect(BaseFee.count).to eq 1
    expect(response).to have_http_status :found
    expect(response).to redirect_to condo_path(condo.id)
    expect(BaseFee.last.description).to eq 'Descrição'
    expect(BaseFee.last.charge_day).to eq 10.days.from_now.to_date
    expect(BaseFee.last.values.count).to eq 2
  end

  it 'com sucesso - Admin com acesso' do
    admin = create(:admin, email: 'admin@email.com', password: '123456', super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                               unit_ids: [])
    unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quarto', metreage: 200, fraction: 2.0,
                               unit_ids: [])

    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return(unit_types)
    AssociatedCondo.create(admin:, condo_id: condo.id)

    login_as admin, scope: :admin
    post(condo_base_fees_path(condo.id), params: { base_fee: { name: 'Nome',
                                                               description: 'Descrição',
                                                               interest_rate: 2,
                                                               late_fine: 30,
                                                               charge_day: 10.days.from_now,
                                                               condo_id: condo.id,
                                                               values_attributes: {
                                                                 '0': {
                                                                   price: 100,
                                                                   unit_type_id: unit_types.first.id
                                                                 },
                                                                 '1': {
                                                                   price: 100,
                                                                   unit_type_id: unit_types.last.id
                                                                 }
                                                               } } })

    expect(BaseFee.count).to eq 1
    expect(response).to have_http_status :found
    expect(response).to redirect_to condo_path(condo.id)
    expect(BaseFee.last.description).to eq 'Descrição'
    expect(BaseFee.last.charge_day).to eq 10.days.from_now.to_date
    expect(BaseFee.last.values.count).to eq 2
  end

  it 'falha pois não está associado' do
    admin = create(:admin, email: 'admin@email.com', password: '123456', super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                               unit_ids: [])
    unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quarto', metreage: 200, fraction: 2.0,
                               unit_ids: [])

    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return(unit_types)

    login_as admin, scope: :admin
    post(condo_base_fees_path(condo.id), params: { base_fee: { name: 'Nome',
                                                               description: 'Descrição',
                                                               late_payment: 2,
                                                               late_fee: 30,
                                                               charge_day: 10.days.from_now,
                                                               condo_id: condo.id,
                                                               values_attributes: {
                                                                 '0': {
                                                                   price: 100,
                                                                   unit_type_id: unit_types.first.id
                                                                 },
                                                                 '1': {
                                                                   price: 100,
                                                                   unit_type_id: unit_types.last.id
                                                                 }
                                                               } } })

    expect(BaseFee.count).to eq 0
    expect(response).to have_http_status :found
    expect(response).to redirect_to root_path
  end
end
