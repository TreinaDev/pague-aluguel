require 'rails_helper'

describe 'Admin creates a base fee' do
  it 'successfully' do
    admin = create(:admin, email: 'admin@email.com', password: '123456')
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.04, condo_id: 1)
    unit_types << UnitType.new(id: 2, area: 30, description: 'Apartamento 2 quarto', ideal_fraction: 0.06, condo_id: 1)

    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:find_all_by_condo).and_return(unit_types)

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
    expect(response).to have_http_status(302)
    expect(response).to redirect_to(condo_path(condo.id))
    expect(BaseFee.last.description).to eq 'Descrição'
    expect(BaseFee.last.charge_day).to eq 10.days.from_now.to_date
    expect(BaseFee.last.values.count).to eq 2
  end

  it 'and is not authenticated' do
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.04, condo_id: 1)
    unit_types << UnitType.new(id: 2, area: 30, description: 'Apartamento 2 quarto', ideal_fraction: 0.06, condo_id: 1)

    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:find_all_by_condo).and_return(unit_types)

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
    expect(response).to have_http_status(302)
    expect(response).to redirect_to(new_admin_session_path)
  end
end
