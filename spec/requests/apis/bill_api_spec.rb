require 'rails_helper'

describe 'API de Faturas' do
  context 'GET /api/v1/bills/:id/' do
    it 'sucesso' do
      create(:bill, condo_id: 1, unit_id: 1, issue_date: Time.zone.today.beginning_of_month,
                    due_date: 10.days.from_now, shared_fee_value_cents: 100_00, base_fee_value_cents: 300_00,
                    single_charge_value_cents: 222_00, rent_fee_cents: 1000_00,
                    total_value_cents: 400_00, status: 'pending')

      get api_v1_bill_path(1)

      expect(response).to have_http_status :ok
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['total_value_cents']).to eq 400_00
      expect(json_response['values']['base_fee_value_cents']).to eq 300_00
      expect(json_response['values']['shared_fee_value_cents']).to eq 100_00
      expect(json_response['values']['single_charge_value_cents']).to eq 222_00
      expect(json_response['values']['rent_fee_cents']).to eq 1000_00
      expect(json_response['issue_date']).to eq Time.zone.today.beginning_of_month.strftime('%Y-%m-%d')
      expect(json_response['due_date']).to eq 10.days.from_now.to_date.strftime('%Y-%m-%d')
      expect(json_response['status']).to eq 'pending'
      expect(json_response['unit_id']).to eq 1
    end

    it 'sucesso mesmo com valores 0' do
      create(:bill, condo_id: 1, unit_id: 1, issue_date: Time.zone.today.beginning_of_month,
                    due_date: 10.days.from_now, shared_fee_value_cents: 100_00, base_fee_value_cents: 0,
                    total_value_cents: 100_00, status: 'pending')

      get api_v1_bill_path(1)

      expect(response).to have_http_status :ok
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['total_value_cents']).to eq 100_00
      expect(json_response['values']['base_fee_value_cents']).to eq 0
      expect(json_response['values']['shared_fee_value_cents']).to eq 100_00
      expect(json_response['issue_date']).to eq Time.zone.today.beginning_of_month.strftime('%Y-%m-%d')
      expect(json_response['due_date']).to eq 10.days.from_now.to_date.strftime('%Y-%m-%d')
      expect(json_response['status']).to eq 'pending'
      expect(json_response['unit_id']).to eq 1
    end

    it 'falha quando fatura não encontrada' do
      get api_v1_bill_path(1)

      expect(response).to have_http_status :not_found
    end
  end

  context 'GET /api/v1/units/:unit_id/bills' do
    it 'sucesso' do
      one_month_ago = 1.month.ago.beginning_of_month.to_date
      two_months_ago = 2.months.ago.beginning_of_month.to_date
      three_months_ago = 3.months.ago.beginning_of_month.to_date
      four_months_ago = 4.months.ago.beginning_of_month.to_date

      unit = Unit.new(id: 1, area: 100, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                      condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 1, description: 'Com varanda')
      unit2 = Unit.new(id: 2, area: 100, floor: 1, number: '12', unit_type_id: 1, condo_id: 1,
                       condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 1, description: 'Com varanda')

      create(:bill, condo_id: 1, unit_id: unit.id, issue_date: one_month_ago, due_date: one_month_ago + 10.days,
                    shared_fee_value_cents: 100_00, base_fee_value_cents: 300_00, total_value_cents: 400_00,
                    status: 'pending')
      create(:bill, condo_id: 1, unit_id: unit.id, issue_date: two_months_ago, due_date: two_months_ago + 10.days,
                    shared_fee_value_cents: 200_00, base_fee_value_cents: 300_00, total_value_cents: 500_00,
                    status: 'pending')
      create(:bill, condo_id: 1, unit_id: unit2.id, issue_date: two_months_ago, due_date: two_months_ago + 10.days,
                    shared_fee_value_cents: 100_00, base_fee_value_cents: 300_00, total_value_cents: 400_00,
                    status: 'pending')
      create(:bill, condo_id: 1, unit_id: unit.id, issue_date: three_months_ago, due_date: three_months_ago + 10.days,
                    shared_fee_value_cents: 100_00, base_fee_value_cents: 300_00, total_value_cents: 400_00,
                    status: 'awaiting')
      create(:bill, condo_id: 1, unit_id: unit.id, issue_date: four_months_ago, due_date: four_months_ago + 10.days,
                    shared_fee_value_cents: 100_00, base_fee_value_cents: 300_00, total_value_cents: 400_00,
                    status: 'paid')

      get api_v1_unit_bills_path(unit.id)

      expect(response).to have_http_status :ok
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['bills'].count).to eq 2
      expect(json_response['bills'].first['id']).to eq 1
      expect(json_response['bills'].first['issue_date']).to eq one_month_ago.strftime('%Y-%m-%d')
      expect(json_response['bills'].first['due_date']).to eq (one_month_ago + 10.days).strftime('%Y-%m-%d')
      expect(json_response['bills'].first['total_value_cents']).to eq 400_00
      expect(json_response['bills'].last['id']).to eq 2
      expect(json_response['bills'].last['issue_date']).to eq two_months_ago.strftime('%Y-%m-%d')
      expect(json_response['bills'].last['due_date']).to eq (two_months_ago + 10.days).strftime('%Y-%m-%d')
      expect(json_response['bills'].last['total_value_cents']).to eq 500_00
    end

    it 'sucesso mesmo quando nao existem faturas' do
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 1, description: 'Com varanda')

      get api_v1_unit_bills_path(units.first.id)

      expect(response).to have_http_status :ok
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['bills']).to be_empty
    end
  end
end
