require 'rails_helper'

describe 'API de Faturas' do
  context 'GET /api/v1/bills/:id/' do
    it 'sucesso' do
      create(:bill, condo_id: 1, unit_id: 1, issue_date: Time.zone.today.beginning_of_month,
                    due_date: 10.days.from_now, shared_fee_value_cents: 100_00, base_fee_value_cents: 300_00,
                    total_value_cents: 400_00, status: 'pending')

      get api_v1_bill_path(1)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['total_value_cents']).to eq 400_00
      expect(json_response['values']['base_fee_value_cents']).to eq 300_00
      expect(json_response['values']['shared_fee_value_cents']).to eq 100_00
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

      expect(response.status).to eq 200
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

      expect(response.status).to eq 404
    end
  end
end
