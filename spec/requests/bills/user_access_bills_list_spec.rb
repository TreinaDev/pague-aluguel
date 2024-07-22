require 'rails_helper'

describe 'Usuario acessa lista de faturas do condominio' do
  it 'sucesso - super admin' do
    admin = create(:admin, super_admin: true)
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    unit = Unit.new(id: 1, area: 40, floor: 3, number: '31', unit_type_id: 1, condo_id: condo.id,
                    condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1, description: 'Com varanda')
    allow(Condo).to receive(:find).and_return(condo)
    allow(Unit).to receive(:find).and_return(unit)

    create(:bill,
           condo_id: condo.id,
           unit_id: 1,
           issue_date: Time.zone.today.beginning_of_month,
           due_date: 10.days.from_now,
           total_value_cents: 500_00,
           status: :pending)

    create(:bill,
           condo_id: condo.id,
           unit_id: 1,
           issue_date: Time.zone.today.beginning_of_month,
           due_date: 10.days.from_now,
           total_value_cents: 111_11,
           status: :pending)

    login_as admin, scope: :admin
    get condo_bills_path(condo.id)

    expect(response).to have_http_status :ok
    expect(response.body).to include('Condomínio Vila das Flores')
    expect(response.body).to include('Fatura')
    expect(response.body).to include('500,00')
    expect(response.body).to include('111,11')
  end

  it 'sucesso - admin associado' do
    admin = create(:admin, super_admin: false)
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    unit = Unit.new(id: 1, area: 40, floor: 3, number: '31', unit_type_id: 1, condo_id: condo.id,
                    condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1, description: 'Com varanda')
    allow(Condo).to receive(:find).and_return(condo)
    allow(Unit).to receive(:find).and_return(unit)

    create(:bill,
           condo_id: condo.id,
           unit_id: 1,
           issue_date: Time.zone.today.beginning_of_month,
           due_date: 10.days.from_now,
           total_value_cents: 500_00,
           status: :pending)

    create(:bill,
           condo_id: condo.id,
           unit_id: 1,
           issue_date: Time.zone.today.beginning_of_month,
           due_date: 10.days.from_now,
           total_value_cents: 111_11,
           status: :pending)

    AssociatedCondo.create!(admin_id: admin.id, condo_id: condo.id)

    login_as admin, scope: :admin
    get condo_bills_path(condo.id)

    expect(response).to have_http_status :ok
    expect(response.body).to include('Condomínio Vila das Flores')
    expect(response.body).to include('Fatura')
    expect(response.body).to include('500,00')
    expect(response.body).to include('111,11')
  end

  it 'erro - admin não associado' do
    admin = create(:admin, super_admin: false)
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)

    create(:bill,
           condo_id: condo.id,
           unit_id: 1,
           issue_date: Time.zone.today.beginning_of_month,
           due_date: 10.days.from_now,
           total_value_cents: 500_00,
           status: :pending)

    login_as admin, scope: :admin
    get condo_bills_path(condo.id)

    expect(response).to have_http_status :found
    expect(response).to redirect_to root_path
    expect(flash[:notice]).to eq 'Você não tem autorização para completar esta ação.'
  end
end
