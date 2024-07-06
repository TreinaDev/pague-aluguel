require 'rails_helper'

describe 'Admin vê histórico de taxas da área comum' do
  it 'e vê todas as taxas' do
    admin = create(:admin)
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    salao_festa = create(:common_area, name: 'Salão de Festas', condo_id: condo.id)
    create(:common_area_fee_history, fee_cents: 250, user: 'user1@example.com',
            common_area: salao_festa, created_at: 60.days.ago)
    create(:common_area_fee_history, fee_cents: 300, user: 'user1@example.com',
            common_area: salao_festa, created_at: 30.days.ago)
    allow(Condo).to receive(:find).and_return(condo)

    create(:common_area, fee: '300,00', condo_id: condo.id)

    login_as admin, scope: :admin
    visit condo_path(condo.id)
    within 'div#first-common-areas' do
      click_on 'Salão de Festas'
    end
    click_on 'Mostrar histórico de taxas'

    expect(page).to have_content 'email user1@example.com', count: 2
    expect(page).to have_content "data de alteração #{30.days.ago.strftime("%d/%m/%Y") }"
    expect(page).to have_content "data de alteração #{60.days.ago.strftime("%d/%m/%Y") }"
    expect(page).to have_content 'taxa R$2,50'
    expect(page).to have_content 'taxa R$3,00'
  end

  it 'em ordem descendente' do
    admin = create(:admin)
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    salao_festa = create(:common_area, name: 'Salão de Festas', condo_id: condo.id)
    fee_1 = create(:common_area_fee_history, fee_cents: 250, user: 'user1@example.com',
            common_area: salao_festa, created_at: 60.days.ago)
    fee_2 = create(:common_area_fee_history, fee_cents: 300, user: 'user1@example.com',
            common_area: salao_festa, created_at: 30.days.ago)
    allow(Condo).to receive(:find).and_return(condo)

    create(:common_area, fee: '300,00', condo_id: condo.id)

    login_as admin, scope: :admin
    visit condo_path(condo.id)
    within 'div#first-common-areas' do
      click_on 'Salão de Festas'
    end
    click_on 'Mostrar histórico de taxas'

    results = CommonAreaFeeHistory.where(common_area: salao_festa).order(created_at: :desc)
    expected_results = [fee_2, fee_1]

    expect(results).to eq(expected_results)
  end

end
