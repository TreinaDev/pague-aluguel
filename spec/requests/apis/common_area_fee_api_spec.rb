require 'rails_helper'

describe 'API das Áreas Comuns' do
  context 'GET /api/v1/condos/:id/common_area_fees' do
    it 'sucesso' do
      admin = create(:admin)
      create(:common_area_fee, value_cents: 200_00, admin:, common_area_id: 1, condo_id: 1)
      create(:common_area_fee, value_cents: 300_00, admin:, common_area_id: 2, condo_id: 1)
      create(:common_area_fee, value_cents: 400_00, admin:, common_area_id: 3, condo_id: 1)
      create(:common_area_fee, value_cents: 500_00, admin:, common_area_id: 4, condo_id: 2)
      create(:common_area_fee, value_cents: 600_00, admin:, common_area_id: 5, condo_id: 3)

      get api_v1_condo_common_area_fees_path(1)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response.length).to eq 3
      expect(json_response[0]['value_cents']).to eq 200_00
      expect(json_response[0]['common_area_id']).to eq 1
      expect(json_response[0]['condo_id']).to eq 1
      expect(json_response[0].keys).not_to include('updated_at')
      expect(json_response[0].keys).not_to include('admin_id')
      expect(json_response[0].keys).not_to include('id')
      expect(json_response[1]['value_cents']).to eq 300_00
      expect(json_response[1]['common_area_id']).to eq 2
      expect(json_response[1]['condo_id']).to eq 1
      expect(json_response[2]['value_cents']).to eq 400_00
      expect(json_response[2]['common_area_id']).to eq 3
      expect(json_response[2]['condo_id']).to eq 1
    end

    it 'e não há taxas cadastradas' do
      admin = create(:admin)
      create(:common_area_fee, value_cents: 200_00, admin:, common_area_id: 1, condo_id: 2)

      get api_v1_condo_common_area_fees_path(1)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response.length).to eq 0
    end

    it 'e retorna a última taxa cadastrada para cada área comum' do
      admin = create(:admin)
      create(:common_area_fee, value_cents: 200_00, admin:, common_area_id: 1, condo_id: 1, created_at: 2.days)
      create(:common_area_fee, value_cents: 300_00, admin:, common_area_id: 1, condo_id: 1, created_at: 1.day)
      create(:common_area_fee, value_cents: 400_00, admin:, common_area_id: 2, condo_id: 1, created_at: 2.days)
      create(:common_area_fee, value_cents: 500_00, admin:, common_area_id: 2, condo_id: 1, created_at: 1.day)

      get api_v1_condo_common_area_fees_path(1)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response.length).to eq 2

      expect(json_response[0]['value_cents']).to eq 300_00
      expect(json_response[0]['common_area_id']).to eq 1
      expect(json_response[0]['condo_id']).to eq 1

      expect(json_response[1]['value_cents']).to eq 500_00
      expect(json_response[1]['common_area_id']).to eq 2
      expect(json_response[1]['condo_id']).to eq 1
    end
  end

  context 'GET /api/v1/common_area_fees/:id' do
    it 'sucesso' do
      admin = create(:admin)
      common_area_fee = create(:common_area_fee, value_cents: 200_00, admin:, common_area_id: 1, condo_id: 1)
      create(:common_area_fee, value_cents: 300_00, admin:, common_area_id: 2, condo_id: 1)

      get api_v1_common_area_fee_path(common_area_fee)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body

      expect(json_response['value_cents']).to eq 200_00
      expect(json_response['common_area_id']).to eq 1
      expect(json_response['condo_id']).to eq 1
      expect(json_response.keys).not_to include('updated_at')
      expect(json_response.keys).not_to include('admin_id')
      expect(json_response.keys).not_to include('id')
    end

    it 'falha' do
      get api_v1_common_area_fee_path(2)

      expect(response.status).to eq 404
    end
  end
end
