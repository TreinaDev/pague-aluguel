require 'rails_helper'

describe 'Admin deleta uma conta compartilhada' do
  it 'a partir da tela de detalhes de uma conta compartilhada' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    condominium = Condo.create!(name: 'Condo Test', city: 'City Test')
    unit_type_one = FactoryBot.create(:unit_type, condo: condominium, ideal_fraction: 0.04)
    unit_type_two = FactoryBot.create(:unit_type, condo: condominium, ideal_fraction: 0.06)
    FactoryBot.create_list(:unit, 9, unit_type: unit_type_one)
    FactoryBot.create_list(:unit, 9, unit_type: unit_type_two)
    unit_one = Unit.create!(area: 40, floor: 1, number: 101, unit_type: unit_type_one)
    unit_two = Unit.create!(area: 60, floor: 2, number: 202, unit_type: unit_type_two)
    bill = SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                      total_value: 10_000, condo: condominium)

    login_as admin, scope: :admin
    visit condo_path(condominium.id)
    click_on 'Gerenciar Condomínio'
    click_on 'Contas Compartilhadas'
    click_on 'Conta de Luz'
    click_on 'Deletar'
    sf = SharedFee.last

    expect(page).to have_content "#{bill.description} deletada com sucesso"
    expect(sf).to eq nil
    expect(current_path).to eq shared_fees_path
  end
end
