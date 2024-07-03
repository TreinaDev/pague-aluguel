require 'rails_helper'

describe 'Admin cria uma nova conta compartilhada' do
  it 'com sucess' do
    admin = Admin.create!(
      email: 'admin@mail.com',
      password: '123456',
      first_name: 'Fulano',
      last_name: 'Da Costa',
      document_number: CPF.generate
    )
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.04, condo_id: 1)
    unit_types << UnitType.new(id: 2, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.06, condo_id: 1)

    units = []
    units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)

    allow(Unit).to receive(:all).and_return(units)
    allow(Condo).to receive(:all).and_return(condos)
    allow(UnitType).to receive(:all).and_return(unit_types)

    login_as admin, scope: :admin
    post(shared_fees_path, params: { shared_fee: { description: 'Descrição',
                                                   issue_date: 10.days.from_now.to_date,
                                                   total_value: 1000,
                                                   condo_id: condos.first.id } })

    expect(SharedFee.count).to eq 1
    expect(response).to have_http_status(302)
    expect(response).to redirect_to(shared_fee_path(SharedFee.last.id.to_s))
    expect(SharedFee.last.description).to eq 'Descrição'
    expect(SharedFee.last.issue_date).to eq 10.days.from_now.to_date
    expect(SharedFee.last.total_value_cents).to eq 100_000
  end

  it 'e não está autenticado' do
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)

    post(shared_fees_path, params: { shared_fee: { description: 'Descrição',
                                                   issue_date: 10.days.from_now.to_date,
                                                   total_value_cents: 1000,
                                                   condo_id: condos.first.id } })

    expect(SharedFee.count).to eq 0
    expect(response).to have_http_status(302)
    expect(response).to redirect_to(new_admin_session_path)
  end
end
