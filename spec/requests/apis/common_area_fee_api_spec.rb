require 'rails_helper'

describe 'API das Áreas Comuns' do
  context'GET /api/v1/condos/:id/common_area_fees' do
    it 'sucesso' do
      admin = create(:admin)
      create(:common_area_fee, value_cents: 200_00, admin:, common_area_id: 1, condo_id: 1)
      create(:common_area_fee, value_cents: 300_00, admin:, common_area_id: 2, condo_id: 1)
      create(:common_area_fee, value_cents: 400_00, admin:, common_area_id: 3, condo_id: 1)
      create(:common_area_fee, value_cents: 500_00, admin:, common_area_id: 4, condo_id: 2)
      create(:common_area_fee, value_cents: 600_00, admin:, common_area_id: 5, condo_id: 3)

      get banana_path(1)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response.length).to eq 3
      expect(json_response[0]['value_cents']).to eq 200_00
      expect(json_response[1]['value_cents']).to eq 300_00
      expect(json_response[2]['value_cents']).to eq 400_00
    end
  end
end
