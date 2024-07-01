require 'rails_helper'

describe 'Admin vê a lista de áreas comuns' do
  it 'se estiver autenticado' do
    condo = create(:condo)

    visit condo_common_areas_path(condo)

    expect(current_path).not_to eq condo_common_areas_path(condo)
    expect(current_path).to eq new_admin_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'com sucesso' do
    admin = create(:admin, email: 'ikki.phoenix@seiya.com', password: 'phoenix123')

    condo = create(:condo, name: 'Teenage Mutant Ninja Turtles')
    create(:common_area, name: 'TMNT', description: 'Teenage Mutant Ninja Turtles', fee_cents: 500_00,
                         condo:)
    create(:common_area, name: 'Saint Seiya', description: 'Os Cavaleiros dos zodíacos', fee_cents: 400_00,
                         condo:)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Lista de Condomínios'
    click_on 'Teenage Mutant Ninja Turtles'
    click_on 'Exibir Áreas Comuns'

    expect(page).to have_content 'Áreas comuns do condomínio Teenage Mutant Ninja Turtles'
    expect(page).to have_content 'TMNT'
    expect(page).to have_content 'Teenage Mutant Ninja Turtles'
    expect(page).to have_content 'R$400,00'
    expect(page).to have_content 'Saint Seiya'
    expect(page).to have_content 'Os Cavaleiros dos zodíacos'
    expect(page).to have_content 'R$500,00'
    expect(page).not_to have_content 'Nenhuma Área Comum cadastrada'
  end

  it 'E não existem áreas comuns cadastradas' do
    admin = create(:admin, email: 'matheus@gmail.com', password: 'admin12345')
    condo = create(:condo)

    login_as admin, scope: :admin
    visit condo_common_areas_path(condo)

    expect(page).to have_content 'Nenhuma Área Comum cadastrada'
  end

  it 'e vê somente as áreas comuns do condomínio selecionado' do
    admin = create(:admin)

    condo = create(:condo)
    second_condo = create(:condo)
    create(:common_area, name: 'TMNT', condo:)
    create(:common_area, name: 'Saint Seiya', condo:)
    create(:common_area, name: 'Naruto', condo: second_condo)
    create(:common_area, name: 'Jiraya', condo: second_condo)

    login_as admin, scope: :admin
    visit condo_common_areas_path(condo)

    expect(page).to have_content 'TMNT'
    expect(page).to have_content 'Saint Seiya'
    expect(page).not_to have_content 'Naruto'
    expect(page).not_to have_content 'Jiraya'
  end

  it 'e vê áreas comuns sem taxa cadastradas' do
    admin = create(:admin)

    condo = create(:condo)
    create(:common_area, name: 'TMNT', fee_cents: 0, condo:)
    create(:common_area, name: 'Saint Seiya', fee_cents: 400, condo:)
    create(:common_area, name: 'Naruto Shippuden', fee_cents: 0, condo:)

    login_as admin, scope: :admin
    visit condo_common_areas_path(condo)

    within 'div#area-0' do
      expect(page).to have_content 'Taxa não cadastrada'
    end
    within 'div#area-1' do
      expect(page).not_to have_content 'Taxa não cadastrada'
    end
    within 'div#area-2' do
      expect(page).to have_content 'Taxa não cadastrada'
    end
  end

  it 'e acessa uma área comum e volta para a lista' do
    admin = create(:admin)

    condo = create(:condo)
    create(:common_area, name: 'TMNT', fee_cents: 400_00, condo:)
    create(:common_area, name: 'Saint Seiya', fee_cents: 500_00, condo:)

    login_as admin, scope: :admin
    visit condo_common_areas_path(condo)
    click_on 'TMNT'
    click_on 'Voltar'

    expect(page).to have_content 'TMNT'
    expect(page).to have_content 'R$400,00'
    expect(page).to have_content 'Saint Seiya'
    expect(page).to have_content 'R$500,00'
  end

  it 'e volta para show do condomínio' do
    admin = create(:admin)

    condo = create(:condo)
    create(:common_area, name: 'TMNT', fee_cents: 400_00, condo:)

    login_as admin, scope: :admin
    visit condo_common_areas_path(condo)
    click_on 'Voltar'

    expect(current_path).to eq condo_path(condo)
  end
end
