require 'rails_helper'

describe 'morador vê comprovante de pagamento' do
  it 'de uma fatura paga' do
    cpf = CPF.generate
    data = Rails.root.join('spec/support/json/tenant.json').read
    response = double('response', success?: true, body: data)
    endpoint_route = "http://127.0.0.1:3000/api/v1/get_tenant_residence?registration_number=#{CPF.new(cpf).formatted}"
    allow(Faraday).to receive(:get).with(endpoint_route).and_return(response)
    residence = JSON.parse(response.body)['resident']['residence']

    condo_id = residence['condo_id']
    number = residence['number']
    unit_id = residence['id']

    units = []
    units << Unit.new(id: unit_id, area: 100, floor: 2, number: 3, unit_type_id: 1)

    allow(Unit).to receive(:find).and_return(units.first)

    create(:bill, condo_id:, unit_id:, issue_date: Time.zone.today.beginning_of_month,
                  due_date: 10.days.from_now, total_value_cents: 500_00, status: :paid)
    create(:receipt, bill_id: Bill.last.id)

    visit root_path
    within 'form#get_tenant_bill' do
      cpf.each_char { |char| find(:css, "input[id$='get_tenant_bill']").send_keys(char) }
      click_on 'Buscar'
    end

    click_on number.to_s
    original_window = page.driver.browser.window_handles.first
    click_link 'Ver comprovante'
    new_window = nil
    sleep 1 until (new_window = page.driver.browser.window_handles.find { |handle| handle != original_window })

    expect(new_window).not_to be_nil
  end
end

describe 'administrador vê comprovante de pagamento' do
  it 'de uma fatura paga' do
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
    bills << create(:bill, condo_id: 1, unit_id: units.first.id, issue_date: Time.zone.today.beginning_of_month,
                           due_date: 10.days.from_now, total_value_cents: 500_00)
    bills << create(:bill, condo_id: 1, unit_id: units.last.id, issue_date: Time.zone.today.beginning_of_month,
                           due_date: 10.days.from_now, total_value_cents: 700_00, status: :paid)
    create(:receipt, bill_id: Bill.last.id)
    login_as admin, scope: :admin
    visit condo_bills_path(condo_id: condo.id)

    click_on 'Unidade 12'
    original_window = page.driver.browser.window_handles.first
    click_link 'Ver comprovante'
    new_window = nil
    sleep 1 until (new_window = page.driver.browser.window_handles.find { |handle| handle != original_window })

    expect(new_window).not_to be_nil
  end
end
