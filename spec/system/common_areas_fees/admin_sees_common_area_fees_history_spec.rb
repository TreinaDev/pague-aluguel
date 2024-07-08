require 'rails_helper'

describe 'Admin vê histórico de taxas da área comum' do
  it 'e vê todas as taxas' do
    admin = create(:admin, email: 'user1@example.com')
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)
    common_areas = []
    common_areas << CommonArea.new(id: 1, name: 'Salão de festa',
                                   description: 'Festa para toda a família.',
                                   max_occupancy: 20, rules: 'Não é permitido a entrada de leões')
    allow(CommonArea).to receive(:all).and_return(common_areas)
    allow(CommonArea).to receive(:find).and_return(common_areas.first)

    create(:common_area_fee, value_cents: 250, admin:, common_area_id: 1, created_at: 60.days.ago)
    create(:common_area_fee, value_cents: 300, admin:, common_area_id: 1, created_at: 30.days.ago)

    login_as admin, scope: :admin
    visit condo_path(condo.id)
    within 'div#common-areas' do
      click_on 'Salão de festa'
    end
    click_on 'Mostrar histórico de taxas'

    expect(page).to have_content 'email user1@example.com', count: 2
    expect(page).to have_content "data de alteração #{30.days.ago.strftime('%d/%m/%Y')}"
    expect(page).to have_content "data de alteração #{60.days.ago.strftime('%d/%m/%Y')}"
    expect(page).to have_content 'taxa R$2,50'
    expect(page).to have_content 'taxa R$3,00'
  end

  it 'em ordem descendente' do
    admin = create(:admin)
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)

    common_areas = []
    common_areas << CommonArea.new(id: 1, name: 'Salão de festa',
                                   description: 'Festa para toda a família.',
                                   max_occupancy: 20, rules: 'Não é permitido a entrada de leões')
    common_area = common_areas.first
    allow(CommonArea).to receive(:all).and_return(common_areas)
    allow(CommonArea).to receive(:find).and_return(common_area)

    fee_one = create(
      :common_area_fee,
      value_cents: 250,
      admin:,
      common_area_id: 1,
      created_at: 60.days.ago
    )
    fee_two = create(
      :common_area_fee,
      value_cents: 300,
      admin:,
      common_area_id: 1,
      created_at: 30.days.ago
    )
    fee_three = create(
      :common_area_fee,
      value_cents: 350,
      admin:,
      common_area_id: 1,
      created_at: 5.days.ago
    )

    login_as admin, scope: :admin
    visit condo_path(condo.id)
    within 'div#common-areas' do
      click_on 'Salão de festa'
    end
    click_on 'Mostrar histórico de taxas'

    results = CommonAreaFee.where(common_area_id: common_area.id).order(created_at: :desc)
    expected_results = [fee_three, fee_two, fee_one]
    expect(results).to eq(expected_results)
  end
end
