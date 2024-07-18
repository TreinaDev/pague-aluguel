require 'rails_helper'

describe 'Admin vê detalhes de uma fatura' do
  it 'a partir da tela de listagem de faturas' do
    admin = create(:admin)
    condos = []
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    condos << condo
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 40, fraction: 0.5,
                               unit_ids: [])
    units = []
    units << Unit.new(id: 1, area: 40, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                      condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1, description: 'Com varanda')
    units << Unit.new(id: 2, area: 40, floor: 1, number: '12', unit_type_id: 1, condo_id: 1,
                      condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1, description: 'Com varanda')
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condo)
    allow(CommonArea).to receive(:all).and_return([])
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(Unit).to receive(:all).and_return(units)
    allow(Unit).to receive(:find).with(1).and_return(units.first)
    allow(Unit).to receive(:find).with(2).and_return(units.second)

    bills = []
    bills << create(:bill, condo_id: 1, unit_id: units[0].id, issue_date: Time.zone.today.beginning_of_month,
                           due_date: 10.days.from_now, total_value_cents: 500_00)
    bills << create(:bill, condo_id: 1, unit_id: units[1].id, issue_date: Time.zone.today.beginning_of_month,
                           due_date: 10.days.from_now, total_value_cents: 700_00)

    login_as admin, scope: :admin
    visit condo_bills_path(condo_id: condo.id)
    click_on 'Unidade 12'

    formatted_issue_date = I18n.l(Time.zone.today.beginning_of_month)
    formatted_due_date = I18n.l(10.days.from_now.to_date)
    expect(page).to have_content 'Fatura'
    expect(page).to have_content 'Unidade 12'
    expect(page).to have_content 'Condomínio Vila das Flores'
    expect(page).to have_content 'data de emissão'
    expect(page).to have_content formatted_issue_date
    expect(page).to have_content 'data de vencimento'
    expect(page).to have_content formatted_due_date
    expect(page).to have_content 'valor total'
    expect(page).to have_content 'R$700,00'
    expect(page).to have_content 'taxa condominial'
    expect(page).to have_content 'conta compartilhada'
  end

  it 'e vê detalhes de cada conta' do
    admin = create(:admin)
    cpf = CPF.generate
    allow(Faraday).to receive(:get).and_return(instance_double('Faraday::Response', success?: true))
    create(:property_owner, email: 'propertyownertest@mail.com', password: '123456',
                            document_number: cpf)
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                               unit_ids: [1])
    units = []
    units << Unit.new(id: 1, area: 100, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                      condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 1, description: 'Com varanda')
    shared_fee = create(:shared_fee, description: 'Conta de Água', issue_date: Time.zone.today,
                                     total_value: 3_000, condo_id: condos.first.id)
    create(:shared_fee_fraction, shared_fee:, unit_id: 1, value_cents: 300_00)
    shared_fee2 = create(:shared_fee, description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                                      total_value: 1_000, condo_id: condos.first.id)
    create(:shared_fee_fraction, shared_fee: shared_fee2, unit_id: 1, value_cents: 100_00)
    base_fee = create(:base_fee, condo_id: condos.first.id, charge_day: Time.zone.today)
    create(:value, price_cents: 100_00, base_fee_id: base_fee.id)
    base_fee2 = create(:base_fee, name: 'Taxa de Manutenção', condo_id: condos.first.id, charge_day: Time.zone.today)
    create(:value, price_cents: 111_00, base_fee_id: base_fee2.id)
    create(:rent_fee, owner_id: 1, tenant_id: 1, unit_id: 1, value_cents: 120_000,
                      issue_date: 1.day.from_now, fine_cents: 5000, fine_interest: 10, condo_id: 1)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(Unit).to receive(:find).and_return(units.first)
    allow(Unit).to receive(:all).and_return(units)
    create(:single_charge, charge_type: :fine, value_cents: 100_11, description: 'Multa por barulho',
                           issue_date: 1.day.from_now, unit_id: 1, condo_id: condos.first.id)
    create(:single_charge, charge_type: :other, value_cents: 150_23,
                           description: 'Acordo entre proprietário e morador',
                           issue_date: 1.day.from_now, unit_id: 1,
                           condo_id: condos.first.id)
    formatted_issue_date = I18n.l(1.month.from_now.beginning_of_month.to_date)
    formatted_due_date = I18n.l((1.month.from_now.beginning_of_month + 9.days).to_date)

    travel_to 1.month.from_now do
      units.each do |unit|
        GenerateMonthlyBillJob.perform_now(unit, condos.first.id)
      end
    end

    login_as admin, scope: :admin
    visit condo_bills_path(condo_id: condos.first.id)
    click_on 'Unidade 11'

    expect(page).to have_content 'Fatura'
    expect(page).to have_content 'Unidade 11'
    expect(page).to have_content 'Condo Test'
    expect(page).to have_content 'data de emissão'
    expect(page).to have_content formatted_issue_date
    expect(page).to have_content 'data de vencimento'
    expect(page).to have_content formatted_due_date
    expect(page).to have_content 'valor total'
    expect(page).to have_content 'R$2.061,34'
    expect(page).to have_content 'total de taxas condominiais'
    expect(page).to have_content 'R$ 211,00'
    expect(page).to have_content 'Taxa de Condomínio'
    expect(page).to have_content 'R$ 100,00'
    expect(page).to have_content 'Taxa de Manutenção'
    expect(page).to have_content 'R$ 111,00'
    expect(page).to have_content 'total de contas compartilhadas'
    expect(page).to have_content 'R$ 400,00'
    expect(page).to have_content 'Conta de Água'
    expect(page).to have_content 'R$ 300,00'
    expect(page).to have_content 'Conta de Luz'
    expect(page).to have_content 'R$ 100,00'
  end
end
