require 'rails_helper'

describe 'Admin vê todos os faturas de um condomínio' do
  it 'a partir da dashboard de admin' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    condos << Condo.new(id: 2, name: 'Residencial Jardim Europa', city: 'Maceió')
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 30, fraction: 1.0,
                               unit_ids: [1, 2])
    unit_types << UnitType.new(id: 2, description: 'Apartamento 1 quarto', metreage: 40, fraction: 1.0,
                               unit_ids: [3])
    units = []
    units << Unit.new(id: 1, area: 100, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                      condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 1, description: 'Com varanda')
    units << Unit.new(id: 2, area: 100, floor: 1, number: '12', unit_type_id: 1, condo_id: 1,
                      condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 1, description: 'Com varanda')
    units << Unit.new(id: 3, area: 100, floor: 3, number: '31', unit_type_id: 2, condo_id: 2,
                      condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 1, description: 'Com churrasqueira')
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos[1])
    allow(CommonArea).to receive(:all).and_return([])
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(Unit).to receive(:all).and_return(units)
    allow(Unit).to receive(:find).with(1).and_return(units.first)
    allow(Unit).to receive(:find).with(2).and_return(units.second)

    bills = []
    bills << create(:bill, condo_id: 2, unit_id: units[0].id, due_date: 10.days.from_now,
                           total_value_cents: 500_00, status: :pending)
    bills << create(:bill, condo_id: 2, unit_id: units[1].id, due_date: 10.days.from_now,
                           total_value_cents: 700_00, status: :awaiting)
    bills << create(:bill, condo_id: 2, unit_id: units[1].id, due_date: 10.days.from_now,
                           total_value_cents: 600_00, status: :awaiting, denied: true)
    bills << create(:bill, condo_id: 1, unit_id: units[2].id, due_date: 10.days.from_now,
                           total_value_cents: 900_00, status: :paid)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Residencial Jardim Europa'
    within('div#bills_section') do
      click_on 'Ver todas'
    end

    formatted_date = I18n.l(10.days.from_now.to_date)
    expect(page).to have_content 'FATURAS'
    expect(page).to have_content 'Residencial Jardim Europa'.upcase
    expect(page).to have_link 'TODAS AS FATURAS'
    expect(page).to have_link 'PAGAS'
    expect(page).to have_link 'NÃO PAGAS'
    within('a#bill_1') do
      expect(page).to have_content 'Unidade 11'
      expect(page).to have_content 'valor total'
      expect(page).to have_content 'R$500,00'
      expect(page).to have_content 'data de vencimento'
      expect(page).to have_content formatted_date
      expect(page).to have_content 'PENDENTE'
    end
    within('a#bill_2') do
      expect(page).to have_content 'Unidade 12'
      expect(page).to have_content 'valor total'
      expect(page).to have_content 'R$700,00'
      expect(page).to have_content 'data de vencimento'
      expect(page).to have_content formatted_date
      expect(page).to have_content 'AGUARDANDO'
    end
    within('a#bill_3') do
      expect(page).to have_content 'Unidade 12'
      expect(page).to have_content 'valor total'
      expect(page).to have_content 'R$600,00'
      expect(page).to have_content 'data de vencimento'
      expect(page).to have_content formatted_date
      expect(page).to have_content 'AGUARDANDO'
    end
    expect(page).not_to have_css 'a#bill_4'
    expect(page).not_to have_content 'R$900,00'
  end

  it 'e não há faturas registradas' do
    admin = create(:admin)
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    condos = []
    condos << condo
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condo)
    allow(CommonArea).to receive(:all).and_return([])

    login_as admin, scope: :admin
    visit condo_bills_path(condo_id: condo.id)

    expect(page).to have_content 'Nenhuma fatura encontrada'
    expect(page).not_to have_css 'a#bill_1'
  end

  it 'e visualiza faturas pagas' do
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
           status: :pending,
           denied: false)

    create(:bill,
           condo_id: condo.id,
           unit_id: 1,
           issue_date: Time.zone.today.beginning_of_month,
           due_date: 10.days.from_now,
           total_value_cents: 111_11,
           status: :pending,
           denied: false)

    create(:bill,
           condo_id: condo.id,
           unit_id: 1,
           issue_date: Time.zone.today.beginning_of_month,
           due_date: 10.days.from_now,
           total_value_cents: 400_00,
           status: :pending,
           denied: true)

    create(:bill,
           condo_id: condo.id,
           unit_id: 1,
           issue_date: Time.zone.today.beginning_of_month,
           due_date: 10.days.from_now,
           total_value_cents: 211_11,
           status: :pending,
           denied: true)

    login_as admin, scope: :admin
    visit condo_bills_path(condo.id)
    click_on 'PAGAS'

    expect(page).to have_content '500,00'
    expect(page).to have_content '111,11'
    expect(page).not_to have_content '400,00'
    expect(page).not_to have_content '211,11'
  end

  it 'e visualiza faturas não pagas' do
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
           status: :pending,
           denied: false)

    create(:bill,
           condo_id: condo.id,
           unit_id: 1,
           issue_date: Time.zone.today.beginning_of_month,
           due_date: 10.days.from_now,
           total_value_cents: 111_11,
           status: :pending,
           denied: false)

    create(:bill,
           condo_id: condo.id,
           unit_id: 1,
           issue_date: Time.zone.today.beginning_of_month,
           due_date: 10.days.from_now,
           total_value_cents: 400_00,
           status: :pending,
           denied: true)

    create(:bill,
           condo_id: condo.id,
           unit_id: 1,
           issue_date: Time.zone.today.beginning_of_month,
           due_date: 10.days.from_now,
           total_value_cents: 211_11,
           status: :pending,
           denied: true)

    login_as admin, scope: :admin
    visit condo_bills_path(condo.id)
    click_on 'NÃO PAGAS'

    expect(page).to have_content '500,00'
    expect(page).to have_content '111,11'
    expect(page).not_to have_content '400,00'
    expect(page).not_to have_content '211,11'
  end
end
