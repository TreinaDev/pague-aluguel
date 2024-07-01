require 'rails_helper'

describe 'Admin vê lista de taxas cadastradas' do
  it 'e deve estar logado' do
    condo = create(:condo, name: 'Prédio lindo')
    create(:base_fee, name: 'Taxa de Condomínio', condo:)
    create(:base_fee, name: 'Taxa de Manutenção', condo:)
    create(:base_fee, name: 'Taxa de Pintura', condo:)

    visit condo_base_fees_path(condo)

    expect(current_path).to eq new_admin_session_path
  end

  it 'com sucesso' do
    admin = create(:admin)
    condo = create(:condo, name: 'Prédio lindo')
    create(:base_fee, name: 'Taxa de Condomínio', condo:)
    create(:base_fee, name: 'Taxa de Manutenção', condo:)
    create(:base_fee, name: 'Taxa de Pintura', condo:)

    login_as admin, scope: :admin

    visit condo_base_fees_path(condo)

    expect(page).to have_link 'Taxa de Condomínio'
    expect(page).to have_link 'Taxa de Manutenção'
    expect(page).to have_link 'Taxa de Pintura'
    expect(page).not_to have_content 'Não existem Taxas Cadastradas.'
  end

  it 'e não tem taxas cadastradas' do
    admin = create(:admin)
    condo = create(:condo, name: 'Prédio lindo')

    login_as admin, scope: :admin

    visit condo_base_fees_path(condo)

    expect(page).to have_content 'Não existem Taxas Cadastradas.'
  end

  it 'e retorna para a tela de condomínio' do
    admin = create(:admin)
    condo = create(:condo, name: 'Prédio lindo')

    login_as admin, scope: :admin

    visit condo_base_fees_path(condo)
    click_on 'Voltar'

    expect(current_path).to eq condo_path(condo)
  end
end
