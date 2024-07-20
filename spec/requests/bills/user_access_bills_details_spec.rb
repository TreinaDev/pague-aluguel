require 'rails_helper'

describe 'Usuario acessa uma fatura' do
  it 'sucesso - super admin' do
    admin = create(:admin, super_admin: true)
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    unit = Unit.new(id: 1, area: 40, floor: 3, number: '31', unit_type_id: 1, condo_id: condo.id,
                    condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1, description: 'Com varanda')
    allow(Condo).to receive(:find).and_return(condo)
    allow(Unit).to receive(:find).and_return(unit)

    bill = create(:bill, id: 1,
                         unit_id: 97,
                         issue_date: Time.zone.today,
                         due_date: 10.days.from_now,
                         total_value_cents: 3_100_00,
                         condo_id: condo.id,
                         status: :pending)

    login_as admin, scope: :admin
    get condo_bill_path(condo.id, bill)

    expect(response).to have_http_status :ok
    expect(response.body).to include 'Fatura'
    expect(response.body).to include 'Unidade 31'
    expect(response.body).to include 'Condomínio Vila das Flores'
    expect(response.body).to include 'valor total'
    expect(response.body).to include 'R$3.100,00'
    expect(response.body).to include 'data de vencimento'
    expect(response.body).to include 'data de emissão'
    expect(response.body).to include 'Pagamento'
    expect(response.body).to include 'Pendente'
  end

  it 'sucesso - admin associado' do
    admin = create(:admin, super_admin: false)
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    unit = Unit.new(id: 1, area: 40, floor: 3, number: '31', unit_type_id: 1, condo_id: condo.id,
                    condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1, description: 'Com varanda')
    allow(Condo).to receive(:find).and_return(condo)
    allow(Unit).to receive(:find).and_return(unit)
    AssociatedCondo.create!(admin_id: admin.id, condo_id: condo.id)

    bill = create(:bill, id: 1,
                         unit_id: 97,
                         issue_date: Time.zone.today,
                         due_date: 10.days.from_now,
                         total_value_cents: 3_100_00,
                         condo_id: condo.id,
                         status: :pending)

    login_as admin, scope: :admin
    get condo_bill_path(condo.id, bill)

    expect(response).to have_http_status :ok
    expect(response.body).to include 'Fatura'
    expect(response.body).to include 'Unidade 31'
    expect(response.body).to include 'Condomínio Vila das Flores'
    expect(response.body).to include 'valor total'
    expect(response.body).to include 'R$3.100,00'
    expect(response.body).to include 'data de vencimento'
    expect(response.body).to include 'data de emissão'
    expect(response.body).to include 'Pagamento'
    expect(response.body).to include 'Pendente'
  end

  it 'erro - admin não associado' do
    admin = create(:admin, super_admin: false)
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    unit = Unit.new(id: 1, area: 40, floor: 3, number: '31', unit_type_id: 1, condo_id: condo.id,
                    condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1, description: 'Com varanda')
    allow(Condo).to receive(:find).and_return(condo)
    allow(Unit).to receive(:find).and_return(unit)

    bill = create(:bill, id: 1,
                         unit_id: 97,
                         issue_date: Time.zone.today,
                         due_date: 10.days.from_now,
                         total_value_cents: 3_100_00,
                         condo_id: condo.id,
                         shared_fee_value_cents: 2_100_00,
                         base_fee_value_cents: 1_000_00,
                         status: :pending)

    login_as admin, scope: :admin
    get condo_bill_path(condo.id, bill)

    expect(response).to have_http_status :found
    expect(response.body).not_to include 'Fatura'
    expect(response.body).not_to include 'Unidade 31'
    expect(response.body).not_to include 'Condomínio Vila das Flores'
    expect(response.body).not_to include 'valor total'
    expect(response.body).not_to include 'R$3.100,00'
  end

  it 'falha pois tenta acessar fatura de outro condomínio' do
    admin = create(:admin, super_admin: true)
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    condo2 = Condo.new(id: 2, name: 'Condomínio Paraíso', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo2)

    bill = create(:bill,
                  condo_id: condo.id,
                  unit_id: 1,
                  issue_date: Time.zone.today.beginning_of_month,
                  due_date: 10.days.from_now,
                  total_value_cents: 500_00,
                  status: :pending)

    login_as admin, scope: :admin
    get condo_bill_path(condo2.id, bill)

    expect(response).to have_http_status :found
    expect(response).to redirect_to condo_bills_path(condo2.id)
    expect(flash[:notice]).to eq I18n.t('views.index.no_bills')
  end
end
