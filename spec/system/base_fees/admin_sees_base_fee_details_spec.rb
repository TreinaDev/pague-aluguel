require 'rails_helper'

describe 'admin vê taxa fixa' do
  it 'com sucesso' do
    admin = create(:admin)
    condo = create(:condo)
    unit_type1 = create(:unit_type, description: 'Apartamento 1 quarto', condo: condo)
    unit_type2 = create(:unit_type, description: 'Apartamento 2 quartos', condo: condo)
    unit_type3 = create(:unit_type, description: 'Apartamento 3 quartos', condo: condo)
    base_fee = create(:base_fee, name: 'Taxa de Condomínio', description: 'Manutenção.',
                      late_payment: 2, late_fee: 10, fixed: true,
                      charge_day: 25.days.from_now,
                      recurrence: :bimonthly, condo: condo)
    value1 = create(:value, price: 200, unit_type: unit_type1, base_fee: base_fee )
    value2 = create(:value, price: 300, unit_type: unit_type2, base_fee: base_fee )
    value3 = create(:value, price: 500, unit_type: unit_type3, base_fee: base_fee )

    login_as admin, scope: :admin
    visit condo_base_fee_path(condo, base_fee)

    formatted_date = 25.days.from_now.to_date

    expect(page).to have_content 'Taxa de Condomínio'
    expect(page).to have_content 'Descrição:'
    expect(page).to have_content 'Manutenção.'
    expect(page).to have_content 'Recorrência:'
    expect(page).to have_content 'Bimestral'
    expect(page).to have_content "Data de Lançamento:"
    expect(page).to have_content "#{I18n.l(formatted_date)}"
    expect(page).to have_content "Valor para #{unit_type1.description}:"
    expect(page).to have_content "R$ 200,00"
    expect(page).to have_content "Valor para #{unit_type2.description}:"
    expect(page).to have_content "R$ 300,00"
    expect(page).to have_content "Valor para #{unit_type3.description}:"
    expect(page).to have_content "R$ 500,00"
    expect(page).to have_content 'Taxa fixa'
    expect(page).to have_content 'Juros de 2% ao dia'
    expect(page).to have_content 'Multa de R$10 por atraso'
  end

  it 'e retorna para home page' do
    admin = create(:admin)
    condo = create(:condo)
    unit_type1 = create(:unit_type)
    base_fee = create(:base_fee, name: 'Taxa', description: 'Manutenção.',
                      late_payment: 2, late_fee: 10, fixed: true,
                      charge_day: 25.days.from_now,
                      recurrence: :bimonthly, condo: condo)

    login_as admin, scope: :admin
    visit condo_base_fee_path(condo, base_fee)
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end
end