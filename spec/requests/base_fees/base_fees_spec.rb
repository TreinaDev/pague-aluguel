require 'rails_helper'

describe 'Admin creates a base fee' do
  it 'successfully' do
    admin = create(:admin, email: 'admin@email.com', password: '123456')
    condo = create(:condo, name: 'Condo Test', city: 'City Test')
    unit_type_one = create(:unit_type, condo: condo, ideal_fraction: 0.04)
    unit_type_two = create(:unit_type, condo: condo, ideal_fraction: 0.06)

    login_as admin, scope: :admin
    post(condo_base_fees_path(condo), params: { base_fee: { name: 'Nome',
                                                          description: 'Descrição',
                                                          late_payment: 2,
                                                          late_fee: 30,
                                                          charge_day: 10.days.from_now,
                                                          condo_id: condo.id,
                                                          values_attributes: {
                                                            '0': {
                                                              price_cents: 100,
                                                              unit_type_id: unit_type_one.id},
                                                            '1': {
                                                              price_cents: 100,
                                                              unit_type_id: unit_type_two.id},
                                                            }}})

    expect(BaseFee.count).to eq 1
    expect(response).to have_http_status(302)
    expect(response).to redirect_to(condo_base_fee_path(condo, BaseFee.last.id.to_s))
    expect(BaseFee.last.description).to eq 'Descrição'
    expect(BaseFee.last.charge_day).to eq 10.days.from_now.to_date
    expect(BaseFee.last.values.count).to eq 2
  end

  it 'and is not authenticated' do
    condo = create(:condo, name: 'Condo Test', city: 'City Test')
    unit_type_one = create(:unit_type, condo: condo, ideal_fraction: 0.04)
    unit_type_two = create(:unit_type, condo: condo, ideal_fraction: 0.06)

    post(condo_base_fees_path(condo), params: { base_fee: { name: 'Nome',
                                                          description: 'Descrição',
                                                          late_payment: 2,
                                                          late_fee: 30,
                                                          charge_day: 10.days.from_now,
                                                          condo_id: condo.id,
                                                          values_attributes: {
                                                            '0': {
                                                              price: 100,
                                                              unit_type_id: unit_type_one.id},
                                                            '1': {
                                                              price: 100,
                                                              unit_type_id: unit_type_two.id},
                                                            }}})
    expect(BaseFee.count).to eq 0
    expect(response).to have_http_status(302)
    expect(response).to redirect_to(new_admin_session_path)
  end
end