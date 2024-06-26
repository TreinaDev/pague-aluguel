require 'rails_helper'

describe 'Update Taxas de area comum' do
  it 'se estiver autenticado' do
    condo = Condo.create!(name: 'Sai de baixo', city: 'Rio de Janeiro')

    common_area = CommonArea.create!(name: 'TMNT', description: 'Teenage Mutant Ninja Turtles', max_capacity: 40,
                                     usage_rules: 'Não lutar no salão', condo:)

    put(common_area_path(common_area), params: { common_area: { fee: 300 } })

    expect(response).to redirect_to new_admin_session_path
    expect(CommonArea.first.fee).to eq common_area.fee
  end
end
