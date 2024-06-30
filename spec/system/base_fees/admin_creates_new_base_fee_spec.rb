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

    unit_type1 = create(:unit_type, description: 'Apartamento 1 quarto', area: 30,
                                    condo:)
    unit_type2 = create(:unit_type, description: 'Apartamento 2 quartos', area: 45,
                                    condo:)
    unit_type3 = create(:unit_type, description: 'Apartamento 3 quartos', area: 60,
                                    condo:)

    formatted_date = 10.days.from_now.to_date

    login_as admin, scope: :admin
    visit new_condo_base_fee_path(condo)
    within '.form-base-fees' do
      fill_in 'Nome', with: 'Taxa de Condomínio'
      fill_in 'Descrição', with: 'Taxas mensais para manutenção do prédio.'
      fill_in 'Valor para Apartamento 1 quarto', with: 20_000
      fill_in 'Valor para Apartamento 2 quartos', with: 30_000
      fill_in 'Valor para Apartamento 3 quartos', with: 50_000
      select 'Bimestral', from: 'Recorrência'
      fill_in 'Data de Lançamento', with: formatted_date.to_s
      check 'Taxa fixa'
      fill_in 'Juros ao dia', with: 1
      fill_in 'Multa por atraso', with: 30
      click_on 'Salvar'
    end

    base_fee = BaseFee.last
    expect(page).to have_content 'Taxa cadastrada com sucesso!'
    expect(page).to have_content 'Taxa de Condomínio'
    expect(page).to have_content 'Recorrência: Bimestral'
    expect(page).to have_content "Data de Lançamento: #{I18n.l(formatted_date)}"
    expect(page).to have_content "Valor para #{unit_type1.description}: R$ 200,00"
    expect(page).to have_content "Valor para #{unit_type2.description}: R$ 300,00"
    expect(page).to have_content "Valor para #{unit_type3.description}: R$ 500,00"
    expect(page).to have_content 'Taxa fixa'
    expect(page).to have_content 'Juros de 1% ao dia'
    expect(page).to have_content 'Multa de R$30 por atraso'
    expect(current_path).to eq condo_base_fee_path(condo, base_fee)
  end

  it 'com dados incompletos' do
    admin = create(:admin, email: 'admin@email.com', password: '123456')

    condo = create(:condo, name: 'Prédio lindo', city: 'Cidade maravilhosa')

    create(:unit_type, description: 'Apartamento 1 quarto', area: 30,
                       condo:)
    create(:unit_type, description: 'Apartamento 2 quartos', area: 45,
                       condo:)
    create(:unit_type, description: 'Apartamento 3 quartos', area: 60,
                       condo:)

    login_as admin, scope: :admin
    visit new_condo_base_fee_path(condo)
    within '.form-base-fees' do
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
    expect(page).to have_content 'Valor não é um número'
    expect(page).to have_content 'Data de Lançamento não pode ficar em branco'
    expect(page).to have_content 'Juros ao dia não pode ficar em branco'
    expect(page).to have_content 'Multa por atraso não pode ficar em branco'
  end

  it 'e data deve ser futura' do
    admin = create(:admin, email: 'admin@email.com', password: '123456')
    condo = create(:condo, name: 'Prédio lindo', city: 'Cidade maravilhosa')

    create(:unit_type, description: 'Apartamento 1 quarto', area: 30, condo:)
    create(:unit_type, description: 'Apartamento 2 quartos', area: 45, condo:)
    create(:unit_type, description: 'Apartamento 3 quartos', area: 60, condo:)

    formatted_date = 10.days.ago.to_date

    login_as admin, scope: :admin
    visit new_condo_base_fee_path(condo)
    within '.form-base-fees' do
      fill_in 'Nome', with: 'Taxa de Condomínio'
      fill_in 'Descrição', with: 'Taxas mensais para manutenção do prédio.'
      fill_in 'Valor para Apartamento 1 quarto', with: 20_000
      fill_in 'Valor para Apartamento 2 quartos', with: 30_000
      fill_in 'Valor para Apartamento 3 quartos', with: 50_000
      select 'Semestral', from: 'Recorrência'
      fill_in 'Data de Lançamento', with: formatted_date.to_s
      check 'Taxa fixa'
      fill_in 'Juros ao dia', with: 1
      fill_in 'Multa por atraso', with: 30
      click_on 'Salvar'
    end

    expect(page).to have_content 'Taxa não cadastrada.'
    expect(page).to have_content 'Data de Lançamento deve ser futura'
    expect(page).to have_field 'Nome', with: 'Taxa de Condomínio'
    expect(page).to have_field 'Descrição', with: 'Taxas mensais para manutenção do prédio.'
    expect(page).to have_field 'Valor para Apartamento 1 quarto', with: 20_000
    expect(page).to have_field 'Valor para Apartamento 2 quartos', with: 30_000
    expect(page).to have_field 'Valor para Apartamento 3 quartos', with: 50_000
    expect(page).to have_checked_field 'Taxa fixa'
    expect(page).to have_field 'Juros ao dia', with: 1
    expect(page).to have_field 'Multa por atraso', with: 30
  end

  it 'e valor deve ser maior que 0' do
    admin = create(:admin, email: 'admin@email.com', password: '123456')
    condo = create(:condo, name: 'Prédio lindo', city: 'Cidade maravilhosa')

    create(:unit_type, description: 'Apartamento 1 quarto', area: 30, condo:)
    create(:unit_type, description: 'Apartamento 2 quartos', area: 45, condo:)
    create(:unit_type, description: 'Apartamento 3 quartos', area: 60, condo:)

    formatted_date = 10.days.from_now.to_date

    login_as admin, scope: :admin
    visit new_condo_base_fee_path(condo)
    within '.form-base-fees' do
      fill_in 'Nome', with: 'Taxa de Condomínio'
      fill_in 'Descrição', with: 'Taxas mensais para manutenção do prédio.'
      fill_in 'Valor para Apartamento 1 quarto', with: 0
      fill_in 'Valor para Apartamento 2 quartos', with: -20_000
      fill_in 'Valor para Apartamento 3 quartos', with: 50_000
      select 'Semestral', from: 'Recorrência'
      fill_in 'Data de Lançamento', with: formatted_date.to_s
      check 'Taxa fixa'
      fill_in 'Juros ao dia', with: 1
      fill_in 'Multa por atraso', with: 30
      click_on 'Salvar'
    end

    expect(page).to have_content 'Taxa não cadastrada.'
    expect(page).to have_content 'Valor deve ser maior que 0', count: 2
  end
end
