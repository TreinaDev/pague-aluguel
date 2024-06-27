require 'rails_helper'

describe 'Admin creates a shared fee' do
  it 'successfully' do
    admin = Admin.create!(email: 'admin@email.com', password: '123456')
    condominio = Condo.create!(name: 'Condo Test', city: 'City Test')
    unit_type_one = FactoryBot.create(:unit_type, condo: condominio, ideal_fraction: 0.04)
    unit_type_two = FactoryBot.create(:unit_type, condo: condominio, ideal_fraction: 0.06)
    FactoryBot.create_list(:unit, 10, unit_type: unit_type_one)
    FactoryBot.create_list(:unit, 10, unit_type: unit_type_two)

    login_as admin, scope: :admin
    post(shared_fees_path, params: { shared_fee: { description: 'Descrição',
                                                   issue_date: 10.days.from_now.to_date,
                                                   total_value_cents: 1000,
                                                   condo_id: condominio.id } })

    expect(SharedFee.count).to eq 1
    expect(response).to have_http_status(302)
    expect(response).to redirect_to(shared_fee_path(SharedFee.last.id.to_s))
    expect(SharedFee.last.description).to eq 'Descrição'
    expect(SharedFee.last.issue_date).to eq 10.days.from_now.to_date
    expect(SharedFee.last.total_value_cents).to eq 1000
  end

  it 'and is not authenticated' do
    Admin.create!(email: 'admin@email.com', password: '123456')
    condominio = Condo.create!(name: 'Condo Test', city: 'City Test')
    unit_type_one = FactoryBot.create(:unit_type, condo: condominio, ideal_fraction: 0.04)
    unit_type_two = FactoryBot.create(:unit_type, condo: condominio, ideal_fraction: 0.06)
    FactoryBot.create_list(:unit, 10, unit_type: unit_type_one)
    FactoryBot.create_list(:unit, 10, unit_type: unit_type_two)

    post(shared_fees_path, params: { shared_fee: { description: 'Descrição',
                                                   issue_date: 10.days.from_now.to_date,
                                                   total_value_cents: 1000,
                                                   condo_id: condominio.id } })

    expect(SharedFee.count).to eq 0
    expect(response).to have_http_status(302)
    expect(response).to redirect_to(new_admin_session_path)
  end
end
