require 'rails_helper'

describe 'Admin tenta acessar lista de contas compartilhadas' do
  it 'e vê lista de contas compartilhadas' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    condominium = Condo.create!(name: 'Edifício Monte Verde', city: 'Recife')
    condominium_two = Condo.create!(name: 'Condomínio Lagoa Serena', city: 'Caxias do Sul')
    unit_type = FactoryBot.create(:unit_type, condo: condominium, ideal_fraction: 0.1)
    FactoryBot.create_list(:unit, 10, unit_type:)
    SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                      total_value: 10_000, condo: condominium)
    SharedFee.create!(description: 'Conta de Água', issue_date: 15.days.from_now.to_date,
                      total_value: 5_000, condo: condominium)
    SharedFee.create!(description: 'Conta de Carro Pipa', issue_date: 5.days.from_now.to_date,
                      total_value: 25_000, condo: condominium_two)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Lista de Condomínios'
    click_on 'Edifício Monte Verde'
    click_on 'Exibir Contas Compartilhadas'

    expect(page).to have_content('Conta de Luz')
    expect(page).to have_content('R$10.000,00')
    expect(page).to have_content(I18n.l(10.days.from_now.to_date).to_s)
    expect(page).to have_content('Conta de Água')
    expect(page).to have_content('R$5.000,00')
    expect(page).to have_content(I18n.l(15.days.from_now.to_date).to_s)
    expect(page).not_to have_content('Conta de Carro Pipa')
    expect(page).not_to have_content('R$25.000,00')
    expect(page).not_to have_content(I18n.l(5.days.from_now.to_date).to_s)
  end

  it 'e acessa a página de uma conta compartilhada na lista' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    condominium = Condo.create!(name: 'Edifício Monte Verde', city: 'Recife')
    condominium_two = Condo.create!(name: 'Condomínio Lagoa Serena', city: 'Caxias do Sul')
    unit_type = FactoryBot.create(:unit_type, condo: condominium, ideal_fraction: 0.1)
    FactoryBot.create_list(:unit, 10, unit_type:)
    SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                      total_value: 10_000, condo: condominium)
    conta_de_agua = SharedFee.create!(description: 'Conta de Água', issue_date: 15.days.from_now.to_date,
                                      total_value: 5_000, condo: condominium)
    SharedFee.create!(description: 'Conta de Carro Pipa', issue_date: 5.days.from_now.to_date,
                      total_value: 25_000, condo: condominium_two)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Lista de Condomínios'
    click_on 'Edifício Monte Verde'
    click_on 'Exibir Contas Compartilhadas'
    click_on 'Conta de Água'

    expect(current_path).to eq shared_fee_path(conta_de_agua.id)
    expect(page).to have_content 'Conta de Água'
    expect(page).to have_content 'R$5.000,00'
  end

  it 'e não está autenticado' do
    FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')

    visit shared_fees_path

    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
    expect(current_path).to eq new_admin_session_path
  end

  it 'e não possui contas compartilhadas registradas' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    condominium = Condo.create!(name: 'Edifício Monte Verde', city: 'Recife')
    unit_type = FactoryBot.create(:unit_type, condo: condominium, ideal_fraction: 0.1)
    FactoryBot.create_list(:unit, 10, unit_type:)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Lista de Condomínios'
    click_on 'Edifício Monte Verde'
    click_on 'Exibir Contas Compartilhadas'

    expect(page).to have_content('Não foram encontradas contas compartilhadas.')
    expect(current_path).to eq shared_fees_path
  end
end
