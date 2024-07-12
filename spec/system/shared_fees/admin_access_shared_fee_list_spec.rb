require 'rails_helper'

describe 'Admin tenta acessar lista de contas compartilhadas' do
  it 'e vê lista de contas compartilhadas' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    condos = []
    condos << Condo.new(id: 1, name: 'Edifício Monte Verde', city: 'Recife')
    condos << Condo.new(id: 2, name: 'Condomínio Lagoa Serena', city: 'Caxias do Sul')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.1,
                               condo_id: 1)
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(UnitType).to receive(:find_all_by_condo).and_return(unit_types)
    allow(CommonArea).to receive(:all).and_return([])

    SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                      total_value: 10_000, condo_id: condos.first.id)
    SharedFee.create!(description: 'Conta de Água', issue_date: 15.days.from_now.to_date,
                      total_value: 5_000, condo_id: condos.first.id)
    SharedFee.create!(description: 'Conta de Carro Pipa', issue_date: 5.days.from_now.to_date,
                      total_value: 25_000, condo_id: condos.last.id)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Edifício Monte Verde'
    within 'div#shared-fee' do
      click_on 'Ver todas'
    end

    expect(page).to have_content 'Conta de Luz'
    expect(page).to have_content 'R$10.000,00'
    expect(page).to have_content I18n.l(10.days.from_now.to_date).to_s
    expect(page).to have_content 'Conta de Água'
    expect(page).to have_content 'R$5.000,00'
    expect(page).to have_content I18n.l(15.days.from_now.to_date).to_s
    expect(page).not_to have_content 'Conta de Carro Pipa'
    expect(page).not_to have_content 'R$25.000,00'
    expect(page).not_to have_content I18n.l(5.days.from_now.to_date).to_s
  end

  it 'e retorna para a tela de condomínio' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.1,
                               condo_id: 1)
    allow(UnitType).to receive(:find_all_by_condo).and_return(unit_types)
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(CommonArea).to receive(:all).and_return([])

    SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                      total_value: 10_000, condo_id: condos.first.id)
    SharedFee.create!(description: 'Conta de Água', issue_date: 15.days.from_now.to_date,
                      total_value: 5_000, condo_id: condos.first.id)
    SharedFee.create!(description: 'Conta de Carro Pipa', issue_date: 5.days.from_now.to_date,
                      total_value: 25_000, condo_id: condos.first.id)

    login_as admin, scope: :admin
    visit condo_path(condos.first.id)
    within 'div#shared-fee' do
      click_on 'Ver todas'
    end
    find('#arrow-left').click

    expect(current_path).to eq condo_path(condos.first.id)
  end

  it 'e acessa a página de uma conta compartilhada na lista' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')

    condos = []
    condos << Condo.new(id: 1, name: 'Edifício Monte Verde', city: 'Recife')
    condos << Condo.new(id: 2, name: 'Condomínio Lagoa Serena', city: 'Caxias do Sul')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.1, condo_id: 1)

    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(UnitType).to receive(:find_all_by_condo).and_return(unit_types)
    allow(CommonArea).to receive(:all).and_return([])

    SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                      total_value: 10_000, condo_id: condos.first.id)
    SharedFee.create!(description: 'Conta de Água', issue_date: 15.days.from_now.to_date,
                      total_value: 5_000, condo_id: condos.first.id)
    SharedFee.create!(description: 'Conta de Carro Pipa', issue_date: 5.days.from_now.to_date,
                      total_value: 25_000, condo_id: condos.last.id)

    login_as admin, scope: :admin
    visit condo_path(condos.first.id)
    within 'div#shared-fee' do
      click_on 'Ver todas'
    end
    click_on 'Conta de Água'

    expect(current_path).to eq condo_shared_fees_path(condos.first.id)
    expect(page).to have_content 'Conta de Água'
    expect(page).to have_content 'R$5.000,00'
    expect(page).to have_content 15.days.from_now.strftime('%d/%m/%Y')
    expect(page).to have_content 'valor total'
    expect(page).to have_content 'R$5.000,00'
  end

  it 'e acessa a página de uma conta compartilhada e volta para listagem' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')

    condos = []
    condos << Condo.new(id: 1, name: 'Edifício Monte Verde', city: 'Recife')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.1, condo_id: 1)

    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(UnitType).to receive(:find_all_by_condo).and_return(unit_types)

    SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                      total_value: 10_000, condo_id: condos.first.id)

    login_as admin, scope: :admin
    visit condo_shared_fees_path(condos.first.id)
    click_on 'Conta de Luz'
    find('#close').click

    expect(page).not_to have_content 15.days.from_now.to_date
    expect(page).not_to have_content 'CANCELAR'
    expect(current_path).to eq condo_shared_fees_path(condos.first.id)
  end

  it 'e não está autenticado' do
    FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')

    condo = Condo.new(id: 1, name: 'Edifício Monte Verde', city: 'Recife')
    allow(Condo).to receive(:find).and_return(condo)

    visit condo_shared_fees_path(condo.id)

    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
    expect(current_path).to eq new_admin_session_path
  end

  it 'e não possui contas compartilhadas registradas' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    condos = []
    condos << Condo.new(id: 1, name: 'Edifício Monte Verde', city: 'Recife')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.1, condo_id: 1)
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(UnitType).to receive(:find_all_by_condo).and_return(unit_types)

    login_as admin, scope: :admin
    visit condo_shared_fees_path(condos.first.id)

    expect(page).to have_content('Não foram encontradas contas compartilhadas.')
    expect(current_path).to eq condo_shared_fees_path(condos.first.id)
  end

  it 'e ve a lista de mais recentes no dashboard do condomínio' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    condos = []
    condos << Condo.new(id: 1, name: 'Edifício Monte Verde', city: 'Recife')
    condos << Condo.new(id: 2, name: 'Condomínio Lagoa Serena', city: 'Caxias do Sul')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.1, condo_id: 1)
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(UnitType).to receive(:find_all_by_condo).and_return(unit_types)
    allow(CommonArea).to receive(:all).and_return([])
    SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                      total_value: 10_000, condo_id: condos.first.id)
    SharedFee.create!(description: 'Conta de Água', issue_date: 15.days.from_now.to_date,
                      total_value: 5_000, condo_id: condos.first.id)
    SharedFee.create!(description: 'Conta de Carro Pipa', issue_date: 5.days.from_now.to_date,
                      total_value: 25_000, condo_id: condos.last.id)

    login_as admin, scope: :admin
    visit condo_path(condos.first.id)

    expect(current_path).to eq condo_path(condos.first.id)
    expect(page).to have_content 'Conta de Água'
    expect(page).to have_content 'R$5.000,00'
    expect(page).to have_content 15.days.from_now.strftime('%d/%m/%Y')
    expect(page).to have_content 'valor total'
    expect(page).to have_content 'R$5.000,00'
    expect(page).to have_content 'Conta de Luz'
    expect(page).to have_content 'R$10.000,00'
    expect(page).not_to have_content 'Conta de Carro Pipa'
  end
end
