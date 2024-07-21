require 'rails_helper'

describe 'usuário não autenticado tenta mudar status de fatura' do
  it 'para pago - aceitando o pagamento' do
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 40, fraction: 0.5,
                               unit_ids: [])
    units = []
    units << Unit.new(id: 1, area: 40, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                      condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1, description: 'Com varanda')
    allow(Condo).to receive(:find).and_return(condo)
    allow(CommonArea).to receive(:all).and_return([])
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(Unit).to receive(:all).and_return(units)
    allow(Unit).to receive(:find).and_return(units.first)

    bill = create(
      :bill,
      condo_id: 1,
      unit_id: units[0].id,
      issue_date: Time.zone.today.beginning_of_month,
      due_date: 10.days.from_now,
      total_value_cents: 500_00,
      status: :awaiting
    )

    post accept_payment_condo_bill_path(condo.id, bill)

    expect(response).to redirect_to root_path
    expect(flash[:notice]).to eq 'Você não tem autorização para completar esta ação.'
  end
  it 'para pendente - recusando o pagamento' do
    condos = []
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    condos << condo
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 40, fraction: 0.5,
                               unit_ids: [])
    units = []
    units << Unit.new(id: 1, area: 40, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                      condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1, description: 'Com varanda')
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condo)
    allow(CommonArea).to receive(:all).and_return([])
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(Unit).to receive(:all).and_return(units)
    allow(Unit).to receive(:find).and_return(units.first)

    bill = create(
      :bill,
      condo_id: 1,
      unit_id: units[0].id,
      issue_date: Time.zone.today.beginning_of_month,
      due_date: 10.days.from_now,
      total_value_cents: 500_00,
      status: :awaiting
    )

    post reject_payment_condo_bill_path(condo.id, bill)

    expect(response).to redirect_to root_path
    expect(flash[:notice]).to eq 'Você não tem autorização para completar esta ação.'
  end
end
describe 'administrador não associado ao condominio daquela fatura' do
  context 'tenta mudar status da fatura' do
    it 'para pago - aceitando o pagamento' do
      admin = create(:admin, super_admin: false)
      condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 40, fraction: 0.5,
                                 unit_ids: [])
      units = []
      units << Unit.new(id: 1, area: 40, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1, description: 'Com varanda')
      allow(Condo).to receive(:find).and_return(condo)
      allow(CommonArea).to receive(:all).and_return([])
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:all).and_return(units)
      allow(Unit).to receive(:find).and_return(units.first)

      bill = create(
        :bill,
        condo_id: 1,
        unit_id: units[0].id,
        issue_date: Time.zone.today.beginning_of_month,
        due_date: 10.days.from_now,
        total_value_cents: 500_00,
        status: :awaiting
      )

      login_as admin, scope: :admin

      post accept_payment_condo_bill_path(condo.id, bill)

      expect(response).to redirect_to root_path
      expect(flash[:notice]).to eq 'Você não tem autorização para completar esta ação.'
    end
    it 'para pendente - recusando o pagamento' do
      admin = create(:admin, super_admin: false)
      condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 40, fraction: 0.5,
                                 unit_ids: [])
      units = []
      units << Unit.new(id: 1, area: 40, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1, description: 'Com varanda')
      allow(Condo).to receive(:find).and_return(condo)
      allow(CommonArea).to receive(:all).and_return([])
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:all).and_return(units)
      allow(Unit).to receive(:find).and_return(units.first)

      bill = create(
        :bill,
        condo_id: 1,
        unit_id: units[0].id,
        issue_date: Time.zone.today.beginning_of_month,
        due_date: 10.days.from_now,
        total_value_cents: 500_00,
        status: :awaiting
      )

      login_as admin, scope: :admin

      post reject_payment_condo_bill_path(condo.id, bill)

      expect(response).to redirect_to root_path
      expect(flash[:notice]).to eq 'Você não tem autorização para completar esta ação.'
    end
  end
end
