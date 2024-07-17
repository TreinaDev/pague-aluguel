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
      floor = residence['floor']
      number = residence['number']
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

      formatted_due_date = I18n.l(10.days.from_now.to_date)
      expect(page).to have_content 'FATURA'
      expect(page).to have_content condo_name.upcase
      expect(page).to have_content "Unidade #{number}"
      expect(page).to have_content 'data de vencimento'
      expect(page).to have_content formatted_due_date
      expect(page).to have_content 'valor total'
      expect(page).to have_content 'R$500,00'
    end
    it 'e clica em uma' do
      cpf = CPF.generate
      data = Rails.root.join('spec/support/json/tenant.json').read
      response = double('response', success?: true, body: data)
      endpoint_route = "http://127.0.0.1:3000/api/v1/get_tenant_residence?registration_number=#{CPF.new(cpf).formatted}"
      allow(Faraday).to receive(:get).with(endpoint_route).and_return(response)
      residence = JSON.parse(response.body)['resident']['residence']

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
    end
  end
end
