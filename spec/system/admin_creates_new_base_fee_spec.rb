require 'rails_helper'

describe 'admin cria taxa fixa' do
  it 'e deve estar logado' do
    condo = create(:condo, name: 'Prédio lindo', city: 'Cidade maravilhosa')

    visit new_condo_base_fee_path(condo)

    expect(current_path).to eq new_admin_session_path
  end

  it 'com sucesso' do
    admin = create(:admin, email: 'admin@email.com', password: '123456')

    condo = create(:condo, name: 'Prédio lindo', city: 'Cidade maravilhosa')
    condo2 = create(:condo, name: 'Prédio legal', city: 'Cidade massa')

    unit_type1 = create(:unit_type, description: 'Apartamento 1 quarto', area: 30,
                  condo: condo)
    unit_type2 = create(:unit_type, description: 'Apartamento 2 quartos', area: 45,
                  condo: condo)
    unit_type3 = create(:unit_type, description: 'Apartamento 3 quartos', area: 60,
                  condo: condo)

    login_as admin, scope: :admin

    visit new_condo_base_fee_path(condo)
    within 'form' do
      fill_in 'Nome', with: 'Taxa de Condomínio'
      fill_in 'Valor para Apartamento 1 quarto', with: 200
      fill_in 'Valor para Apartamento 2 quartos', with: 300
      fill_in 'Valor para Apartamento 3 quartos', with: 500
      select 'Mensal', from: 'Recorrência'
      fill_in 'Dia de lançamento', with: 1.day.from_now
      check 'Taxa fixa'
      fill_in 'Juros ao dia', with: 1
      fill_in 'Multa por atraso', with: 30
      click_on 'Salvar'
    end

    expect(current_path).to eq condo_path
    expect(page).to have_content 'Taxa cadastrada com sucesso!'
    expect(page).to have_content 'Taxa de Condomínio'
    expect(page).to have_content "Mensal no dia #{1.day.from_now}"
    expect(page).to have_content 'Taxa fixa'
    expect(page).to have_content 'Juros de 1% ao dia'
    expect(page).to have_content 'Multa de R$30,00 por atraso'
    expect(page).to have_button 'Ver detalhes'
  end
end
