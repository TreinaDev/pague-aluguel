require 'rails_helper'

describe 'Admin cancela uma conta compartilhada' do
  it 'a partir da tela de detalhes de uma conta compartilhada' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.4, condo_id: 1)
    unit_types << UnitType.new(id: 2, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.6, condo_id: 1)
    units = []
    units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
    units << Unit.new(id: 2, area: 100, floor: 1, number: 1, unit_type_id: 2)
    bill = SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                             total_value: 10_000, condo_id: condos.first.id)
    allow(Unit).to receive(:all).and_return(units)
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(UnitType).to receive(:all).and_return(unit_types)

    login_as admin, scope: :admin
    visit condo_path(condos.first.id)
    click_on 'Gerenciar Condomínio'
    click_on 'Contas Compartilhadas'
    click_on 'Conta de Luz'
    click_on 'Cancelar'
    sf = SharedFee.last

    expect(page).to have_content "#{bill.description} cancelada com sucesso"
    expect(sf.active?).to eq false
    expect(sf.canceled?).to eq true
    expect(current_path).to eq shared_fees_path
    expect(page).to have_content 'Cancelada'
  end
end
