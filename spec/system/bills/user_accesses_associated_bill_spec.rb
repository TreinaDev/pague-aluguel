require 'rails_helper'

describe 'Usuário acessa suas faturas' do
  context 'como morador' do
    it 'a partir da homepage' do
      cpf = CPF.generate
      data = Rails.root.join('spec/support/json/tenant.json').read
      response = double('response', success?: true, body: data)
      endpoint_route = "http://127.0.0.1:3000/api/v1/get_tenant_residence?registration_number=#{CPF.new(cpf).formatted}"
      allow(Faraday).to receive(:get).with(endpoint_route).and_return(response)
      residence = JSON.parse(response.body)['resident']['residence']
      resident = JSON.parse(response.body)['resident']

      condo_id = residence['condo_id']
      unit_id = residence['id']

      units = []
      units << Unit.new(id: unit_id, area: 100, floor: 2, number: 23, unit_type_id: 1)
      allow(Unit).to receive(:find).and_return(units.first)

      issue_date1 = Time.zone.today.beginning_of_month
      issue_date2 = 30.days.ago.beginning_of_month
      issue_date3 = 60.days.ago.beginning_of_month
      due_date1 = 10.days.from_now
      due_date2 = 20.days.ago
      due_date3 = 50.days.ago

      create(:bill, condo_id:, unit_id:, issue_date: issue_date1,
                    due_date: due_date1, total_value_cents: 500_00, status: :pending)
      create(:bill, condo_id:, unit_id:, issue_date: issue_date2,
                    due_date: due_date2, total_value_cents: 600_00, status: :awaiting)
      create(:bill, condo_id:, unit_id:, issue_date: issue_date3,
                    due_date: due_date3, total_value_cents: 700_00, status: :paid)

      visit root_path
      within 'form#get_tenant_bill' do
        cpf.each_char { |char| find(:css, "input[id$='get_tenant_bill']").send_keys(char) }
        click_on 'Buscar'
      end

      formatted_issue_date1 = issue_date1.strftime('%d/%m/%Y')
      formatted_issue_date2 = issue_date2.strftime('%d/%m/%Y')
      formatted_issue_date3 = issue_date3.strftime('%d/%m/%Y')
      formatted_due_date1 = due_date1.strftime('%d/%m/%Y')
      formatted_due_date2 = due_date2.strftime('%d/%m/%Y')
      formatted_due_date3 = due_date3.strftime('%d/%m/%Y')
      expect(page).to have_content 'FATURA'
      expect(page).to have_content resident['name'].upcase

      within('a#bill_1') do
        expect(page).to have_content 'Unidade 23'
        expect(page).to have_content 'valor total'
        expect(page).to have_content 'R$500,00'
        expect(page).to have_content 'data de emissão'
        expect(page).to have_content formatted_issue_date1
        expect(page).to have_content 'data de vencimento'
        expect(page).to have_content formatted_due_date1
        expect(page).to have_content 'PENDENTE'
      end
      within('a#bill_2') do
        expect(page).to have_content 'Unidade 23'
        expect(page).to have_content 'valor total'
        expect(page).to have_content 'R$600,00'
        expect(page).to have_content 'data de emissão'
        expect(page).to have_content formatted_issue_date2
        expect(page).to have_content 'data de vencimento'
        expect(page).to have_content formatted_due_date2
        expect(page).to have_content 'AGUARDANDO'
      end
      within('a#bill_3') do
        expect(page).to have_content 'Unidade 23'
        expect(page).to have_content 'valor total'
        expect(page).to have_content 'R$700,00'
        expect(page).to have_content 'data de emissão'
        expect(page).to have_content formatted_issue_date3
        expect(page).to have_content 'data de vencimento'
        expect(page).to have_content formatted_due_date3
        expect(page).to have_content 'PAGA'
      end
    end

    it 'e retorna para listagem' do
      cpf = CPF.generate
      data = Rails.root.join('spec/support/json/tenant.json').read
      response = double('response', success?: true, body: data)
      endpoint_route = "http://127.0.0.1:3000/api/v1/get_tenant_residence?registration_number=#{CPF.new(cpf).formatted}"
      allow(Faraday).to receive(:get).with(endpoint_route).and_return(response)
      residence = JSON.parse(response.body)['resident']['residence']
      resident = JSON.parse(response.body)['resident']

      condo_id = residence['condo_id']
      condo_name = residence['condo_name']
      unit_id = residence['id']

      units = []
      units << Unit.new(id: unit_id, area: 100, floor: 2, number: 3, unit_type_id: 1)

      allow(Unit).to receive(:find).and_return(units.first)

      create(:bill, condo_id:, unit_id:, issue_date: Time.zone.today.beginning_of_month,
                    due_date: 10.days.from_now, total_value_cents: 500_00)

      visit root_path
      within 'form#get_tenant_bill' do
        cpf.each_char { |char| find(:css, "input[id$='get_tenant_bill']").send_keys(char) }
        click_on 'Buscar'
      end

      click_on 'bill_1'
      find('#back').click

      expect(page).not_to have_content CPF.new(cpf).formatted
      expect(page).not_to have_content resident['name']
      expect(page).not_to have_content condo_name
      expect(page).not_to have_content 'Taxa Condominial'.downcase
      expect(page).not_to have_content 'Conta Compartilhada'.downcase
    end
  end
  context 'e falha' do
    it 'quando o cpf é inválido' do
      cpf = '11111111111'
      response = double('response', success?: false, status: 412)
      endpoint_route = "http://127.0.0.1:3000/api/v1/get_tenant_residence?registration_number=#{CPF.new(cpf).formatted}"
      allow(Faraday).to receive(:get).with(endpoint_route).and_return(response)

      visit root_path
      within 'form#get_tenant_bill' do
        cpf.each_char { |char| find(:css, "input[id$='get_tenant_bill']").send_keys(char) }
        click_on 'Buscar'
      end

      expect(page).to have_content 'Documento não é válido.'
    end

    it 'quando o cpf válido não é encontrado no sistema' do
      cpf = CPF.generate
      response = double('response', success?: false, status: 404)
      endpoint_route = "http://127.0.0.1:3000/api/v1/get_tenant_residence?registration_number=#{CPF.new(cpf).formatted}"
      allow(Faraday).to receive(:get).with(endpoint_route).and_return(response)

      visit root_path
      within 'form#get_tenant_bill' do
        cpf.each_char { |char| find(:css, "input[id$='get_tenant_bill']").send_keys(char) }
        click_on 'Buscar'
      end

      expect(page).to have_content 'Documento não encontrado.'
    end
  end
end
describe 'Usuário acessa uma fatura' do
  it 'pendente' do
    cpf = CPF.generate
    data = Rails.root.join('spec/support/json/tenant.json').read
    response = double('response', success?: true, body: data)
    endpoint_route = "http://127.0.0.1:3000/api/v1/get_tenant_residence?registration_number=#{CPF.new(cpf).formatted}"
    allow(Faraday).to receive(:get).with(endpoint_route).and_return(response)
    residence = JSON.parse(response.body)['resident']['residence']
    resident = JSON.parse(response.body)['resident']

    condo_id = residence['condo_id']
    condo_name = residence['condo_name']
    number = residence['number']
    unit_id = residence['id']

    units = []
    units << Unit.new(id: unit_id, area: 100, floor: 2, number: 3, unit_type_id: 1)

    allow(Unit).to receive(:find).and_return(units.first)

    create(:bill, condo_id:, unit_id:, issue_date: Time.zone.today.beginning_of_month,
                  due_date: 10.days.from_now, total_value_cents: 500_00, status: :pending)

    visit root_path
    within 'form#get_tenant_bill' do
      cpf.each_char { |char| find(:css, "input[id$='get_tenant_bill']").send_keys(char) }
      click_on 'Buscar'
    end

    click_on 'bill_1'

    expect(page).to have_content CPF.new(cpf).formatted
    expect(page).to have_content resident['name']
    expect(page).to have_content condo_name
    expect(page).to have_content Time.zone.today.beginning_of_month.strftime('%d/%m/%Y')
    expect(page).to have_content 10.days.from_now.strftime('%d/%m/%Y')
    expect(page).to have_content number
    expect(page).to have_content 'R$500,00'
    expect(page).to have_content 'PENDENTE'
    expect(page).not_to have_button 'Ver comprovante'
    expect(page).not_to have_button 'Aceitar pagamento'
    expect(page).not_to have_button 'Recusar pagamento'
  end
  it 'aguardando' do
    cpf = CPF.generate
    data = Rails.root.join('spec/support/json/tenant.json').read
    response = double('response', success?: true, body: data)
    endpoint_route = "http://127.0.0.1:3000/api/v1/get_tenant_residence?registration_number=#{CPF.new(cpf).formatted}"
    allow(Faraday).to receive(:get).with(endpoint_route).and_return(response)
    residence = JSON.parse(response.body)['resident']['residence']
    resident = JSON.parse(response.body)['resident']

    condo_id = residence['condo_id']
    condo_name = residence['condo_name']
    number = residence['number']
    unit_id = residence['id']

    units = []
    units << Unit.new(id: unit_id, area: 100, floor: 2, number: 3, unit_type_id: 1)

    allow(Unit).to receive(:find).and_return(units.first)

    create(:bill, condo_id:, unit_id:, issue_date: Time.zone.today.beginning_of_month,
                  due_date: 10.days.from_now, total_value_cents: 500_00, status: :awaiting)
    create(:receipt, bill_id: Bill.last.id)

    visit root_path
    within 'form#get_tenant_bill' do
      cpf.each_char { |char| find(:css, "input[id$='get_tenant_bill']").send_keys(char) }
      click_on 'Buscar'
    end

    click_on 'bill_1'

    expect(page).to have_content CPF.new(cpf).formatted
    expect(page).to have_content resident['name']
    expect(page).to have_content condo_name
    expect(page).to have_content Time.zone.today.beginning_of_month.strftime('%d/%m/%Y')
    expect(page).to have_content 10.days.from_now.strftime('%d/%m/%Y')
    expect(page).to have_content number
    expect(page).to have_content 'R$500,00'
    expect(page).to have_content 'AGUARDANDO'
    expect(page).to have_link 'Ver comprovante'
    expect(page).not_to have_button 'Aceitar pagamento'
    expect(page).not_to have_button 'Recusar pagamento'
  end
  it 'paga' do
    cpf = CPF.generate
    data = Rails.root.join('spec/support/json/tenant.json').read
    response = double('response', success?: true, body: data)
    endpoint_route = "http://127.0.0.1:3000/api/v1/get_tenant_residence?registration_number=#{CPF.new(cpf).formatted}"
    allow(Faraday).to receive(:get).with(endpoint_route).and_return(response)
    residence = JSON.parse(response.body)['resident']['residence']
    resident = JSON.parse(response.body)['resident']

    condo_id = residence['condo_id']
    condo_name = residence['condo_name']
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

    click_on 'bill_1'

    expect(page).to have_content CPF.new(cpf).formatted
    expect(page).to have_content resident['name']
    expect(page).to have_content condo_name
    expect(page).to have_content Time.zone.today.beginning_of_month.strftime('%d/%m/%Y')
    expect(page).to have_content 10.days.from_now.strftime('%d/%m/%Y')
    expect(page).to have_content number
    expect(page).to have_content 'R$500,00'
    expect(page).to have_content 'PAGA'
    expect(page).to have_link 'Ver comprovante'
    expect(page).not_to have_button 'Aceitar pagamento'
    expect(page).not_to have_button 'Recusar pagamento'
  end
end
