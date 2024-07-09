require 'rails_helper'

describe 'Update Taxas de area comum' do
  it 'se estiver autenticado' do
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)

    common_area = CommonArea.new(id: 1, name: 'Academia',
                                 description: 'Uma academia raíz com ventilador apenas para os marombas',
                                 max_occupancy: 20, rules: 'Não pode ser frango')
    allow(CommonArea).to receive(:find).and_return(common_area)

    url = condo_common_area_common_area_fees_path(condo.id, common_area.id)
    post url, params: { common_area_fee: { value_cents: 300, common_area_id: common_area.id } }

    expect(response).to redirect_to new_admin_session_path
    expect(CommonAreaFee.count).to be_zero
  end
end
