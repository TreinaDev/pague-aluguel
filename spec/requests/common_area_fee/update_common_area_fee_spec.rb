require 'rails_helper'

describe 'Update Taxas de area comum' do
  it 'se estiver autenticado' do
    condo = FactoryBot.create(:condo)

    common_area = FactoryBot.create(:common_area, condo:)

    put(condo_common_area_path(condo, common_area), params: { common_area: { fee_cents: 300 } })

    expect(response).to redirect_to new_admin_session_path
    expect(CommonArea.first.fee_cents).to eq common_area.fee_cents
  end
end
