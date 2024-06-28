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

    create(:unit_type, description: 'Apartamento 1 quarto', area: 30,
           condo: condo)
    create(:unit_type, description: 'Apartamento 2 quartos', area: 45,
           condo: condo)
    create(:unit_type, description: 'Apartamento 3 quartos', area: 60,
           condo: condo)

    formatted_date = 10.days.from_now.to_date

    login_as admin, scope: :admin
    visit new_condo_base_fee_path(condo)
    within 'form' do
      fill_in 'Nome', with: 'Taxa de Condomínio'
      fill_in 'Descrição', with: 'Taxas mensais para manutenção do prédio.'
      fill_in 'Valor para Apartamento 1 quarto', with: 200
      fill_in 'Valor para Apartamento 2 quartos', with: 300
      fill_in 'Valor para Apartamento 3 quartos', with: 500
      select 'Mensal', from: 'Recorrência'
      fill_in 'Data de Lançamento', with: formatted_date.to_s
      check 'Taxa fixa'
      fill_in 'Juros ao dia', with: 1
      fill_in 'Multa por atraso', with: 30
      click_on 'Salvar'
    end

    base_fee = BaseFee.last
    expect(page).to have_content 'Taxa cadastrada com sucesso!'
    expect(page).to have_content 'Taxa de Condomínio'
    expect(page).to have_content 'Recorrência: Mensal'
    expect(page).to have_content "Data de Lançamento: #{I18n.localize(formatted_date)}"
    expect(page).to have_content 'Taxa fixa'
    expect(page).to have_content 'Juros de 1% ao dia'
    expect(page).to have_content 'Multa de R$30 por atraso'
    expect(current_path).to eq condo_base_fee_path(condo, base_fee)
  end

  it 'com dados incompletos' do
    admin = create(:admin, email: 'admin@email.com', password: '123456')

    condo = create(:condo, name: 'Prédio lindo', city: 'Cidade maravilhosa')

    create(:unit_type, description: 'Apartamento 1 quarto', area: 30,
           condo: condo)
    create(:unit_type, description: 'Apartamento 2 quartos', area: 45,
           condo: condo)
    create(:unit_type, description: 'Apartamento 3 quartos', area: 60,
           condo: condo)

    login_as admin, scope: :admin
    visit new_condo_base_fee_path(condo)
    within 'form' do
      fill_in 'Nome', with: ''
      fill_in 'Descrição', with: ''
      fill_in 'Valor para Apartamento 1 quarto', with: ''
      fill_in 'Valor para Apartamento 2 quartos', with: ''
      fill_in 'Valor para Apartamento 3 quartos', with: ''
      fill_in 'Data de Lançamento', with: ''
      fill_in 'Juros ao dia', with: ''
      fill_in 'Multa por atraso', with: ''
      click_on 'Salvar'
    end

    expect(page).to have_content 'Taxa não cadastrada.'
    expect(page).to have_content 'Verifique os erros abaixo:'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Valor não pode ficar em branco'
    expect(page).to have_content 'Data de Lançamento não pode ficar em branco'
    expect(page).to have_content 'Juros ao dia não pode ficar em branco'
    expect(page).to have_content 'Multa por atraso não pode ficar em branco'
  end
end
