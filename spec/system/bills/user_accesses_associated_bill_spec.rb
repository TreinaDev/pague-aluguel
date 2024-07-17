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

      condo_id = residence['condo_id']
      condo_name = residence['condo_name']
      number = residence['number']
      unit_id = residence['id']

      units = []
      units << Unit.new(id: unit_id, area: 100, floor: 2, number: 3, unit_type_id: 1)
      allow(Unit).to receive(:find).and_return(units.first)

      issue_date1 = Time.zone.today.beginning_of_month
      issue_date2 = 30.days.ago.beginning_of_month
      issue_date3 = 60.days.ago.beginning_of_month
      due_date1 = 10.days.from_now
      due_date2 = 20.days.ago
      due_date3 = 50.days.ago

      create(:bill, condo_id:, unit_id:, issue_date: issue_date1,
                    due_date: due_date1, total_value_cents: 500_00)
      create(:bill, condo_id:, unit_id:, issue_date: issue_date2,
                    due_date: due_date2, total_value_cents: 600_00)
      create(:bill, condo_id:, unit_id:, issue_date: issue_date3,
                    due_date: due_date3, total_value_cents: 700_00)

      visit root_path
      within 'form#get_tenant_bill' do
        cpf.each_char { |char| find(:css, "input[id$='get_tenant_bill']").send_keys(char) }
        click_on 'Buscar'
      end

      formatted_issue_date1 = issue_date1.strftime("%d/%m/%Y")
      formatted_issue_date2 = issue_date2.strftime("%d/%m/%Y")
      formatted_issue_date3 = issue_date3.strftime("%d/%m/%Y")
      formatted_due_date1 = due_date1.strftime("%d/%m/%Y")
      formatted_due_date2 = due_date2.strftime("%d/%m/%Y")
      formatted_due_date3 = due_date3.strftime("%d/%m/%Y")
      expect(page).to have_content 'FATURA'
      expect(page).to have_content condo_name.upcase
      expect(page).to have_content "Unidade #{number}", count: 3
      expect(page).to have_content 'data de emissão', count: 3
      expect(page).to have_content formatted_issue_date1
      expect(page).to have_content formatted_issue_date2
      expect(page).to have_content formatted_issue_date3
      expect(page).to have_content 'data de vencimento', count: 3
      expect(page).to have_content formatted_due_date1
      expect(page).to have_content formatted_due_date2
      expect(page).to have_content formatted_due_date3
      expect(page).to have_content 'valor total', count: 3
      expect(page).to have_content 'R$500,00'
      expect(page).to have_content 'R$600,00'
      expect(page).to have_content 'R$700,00'
    end

    it 'e clica em uma' do
      cpf = CPF.generate
      data = Rails.root.join('spec/support/json/tenant.json').read
      response = double('response', success?: true, body: data)
      endpoint_route = "http://127.0.0.1:3000/api/v1/get_tenant_residence?registration_number=#{CPF.new(cpf).formatted}"
      allow(Faraday).to receive(:get).with(endpoint_route).and_return(response)
      residence = JSON.parse(response.body)['resident']['residence']
      resident = JSON.parse(response.body)['resident']

      condo_id = residence['condo_id']
      condo_name = residence['condo_name']
      floor = residence['floor']
      number = residence['number']
      unit_id = residence['id']

      units = []
      units << Unit.new(id: unit_id, area: 100, floor: 2, number: 3, unit_type_id: 1)

      allow(Unit).to receive(:find).and_return(units.first)

      bill = create(:bill, condo_id:, unit_id:, issue_date: Time.zone.today.beginning_of_month,
                           due_date: 10.days.from_now, total_value_cents: 500_00)

      visit root_path
      within 'form#get_tenant_bill' do
        cpf.each_char { |char| find(:css, "input[id$='get_tenant_bill']").send_keys(char) }
        click_on 'Buscar'
      end

      click_on number.to_s

      expect(page).to have_content CPF.new(cpf).formatted
      expect(page).to have_content resident['name']
      expect(page).to have_content condo_name
      expect(page).to have_content Time.zone.today.beginning_of_month.strftime("%d/%m/%Y")
      expect(page).to have_content 10.days.from_now.strftime("%d/%m/%Y")
      expect(page).to have_content number
      expect(page).to have_content 'R$500,00'
    end
  end
end
