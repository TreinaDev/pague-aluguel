require 'rails_helper'

describe 'Admin cria taxa condominial' do
  it 'e deve estar logado' do
    condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')

    visit new_condo_base_fee_path(condo)

    expect(current_path).to eq new_admin_session_path
  end

  it 'a partir da home page' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                               unit_ids: [])
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos[0])
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(CommonArea).to receive(:all).and_return([])

    login_as admin, scope: :admin
    visit root_path
    click_on 'Prédio lindo'
    within 'div#base-fee' do
      click_on 'Adicionar nova'
    end

    expect(page).to have_content 'CADASTRO DE TAXA CONDOMINIAL'
    expect(page).to have_content 'PRÉDIO LINDO'
    expect(current_path).to eq new_condo_base_fee_path(condos[0].id)
  end

  it 'e campo de parcelas não aparece automaticamente' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                               unit_ids: [])
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos[0])
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(CommonArea).to receive(:all).and_return([])

    login_as admin, scope: :admin
    visit root_path
    click_on 'Prédio lindo'
    within 'div#base-fee' do
      click_on 'Adicionar nova'
    end

    expect(page).to have_content 'CADASTRO DE TAXA CONDOMINIAL'
    expect(page).not_to have_field 'Número de Parcelas'
  end

  it 'fixa com sucesso' do
    admin = create(:admin)
    condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                               unit_ids: [])
    unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quartos', metreage: 200, fraction: 2.0,
                               unit_ids: [])
    unit_types << UnitType.new(id: 3, description: 'Apartamento 3 quartos', metreage: 300, fraction: 3.0,
                               unit_ids: [])
    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return(unit_types)
    common_areas = []
    common_areas << CommonArea.new(id: 3, name: 'Salão de festa',
                                   description: 'Festa para toda a família.',
                                   max_occupancy: 80, rules: 'Não é permitido a entrada de leões')
    allow(CommonArea).to receive(:all).and_return(common_areas)
    formatted_date = 10.days.from_now.to_date

    login_as admin, scope: :admin
    visit new_condo_base_fee_path(condo.id)
    fill_in 'Nome', with: 'Taxa de Condomínio'
    fill_in 'Descrição', with: 'Taxas mensais para manutenção do prédio.'
    fill_in 'Valor para Apartamento 1 quarto', with: '200,00'
    fill_in 'Valor para Apartamento 2 quartos', with: '300,00'
    fill_in 'Valor para Apartamento 3 quartos', with: '500,00'
    select 'Bimestral', from: 'Recorrência'
    fill_in 'Data de Emissão', with: formatted_date.to_s
    fill_in 'Juros ao dia', with: 1
    fill_in 'Multa por atraso', with: '30,00'
    click_on 'Cadastrar'

    expect(page).to have_content 'Taxa cadastrada com sucesso!'
    expect(current_path).to eq condo_path(condo.id)
  end

  it 'limitada com sucesso' do
    admin = create(:admin)
    condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                               unit_ids: [])
    unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quartos', metreage: 200, fraction: 2.0,
                               unit_ids: [])
    unit_types << UnitType.new(id: 3, description: 'Apartamento 3 quartos', metreage: 300, fraction: 3.0,
                               unit_ids: [])
    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return(unit_types)
    common_areas = []
    common_areas << CommonArea.new(id: 3, name: 'Salão de festa',
                                   description: 'Festa para toda a família.',
                                   max_occupancy: 80, rules: 'Não é permitido a entrada de leões')
    allow(CommonArea).to receive(:all).and_return(common_areas)
    formatted_date = 10.days.from_now.to_date

    login_as admin, scope: :admin
    visit new_condo_base_fee_path(condo.id)
    fill_in 'Nome', with: 'Taxa de Condomínio'
    fill_in 'Descrição', with: 'Taxas mensais para manutenção do prédio.'
    fill_in 'Valor para Apartamento 1 quarto', with: '200,00'
    fill_in 'Valor para Apartamento 2 quartos', with: '300,00'
    fill_in 'Valor para Apartamento 3 quartos', with: '500,00'
    select 'Bimestral', from: 'Recorrência'
    fill_in 'Data de Emissão', with: formatted_date.to_s
    check 'Taxa limitada'
    fill_in 'Número de Parcelas', with: 6
    fill_in 'Juros ao dia', with: 1
    fill_in 'Multa por atraso', with: '30,00'
    click_on 'Cadastrar'

    expect(page).to have_content 'Taxa cadastrada com sucesso!'
    expect(current_path).to eq condo_path(condo.id)
  end

  it 'com dados incompletos' do
    admin = create(:admin)
    condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                               unit_ids: [])
    unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quartos', metreage: 200, fraction: 2.0,
                               unit_ids: [])
    unit_types << UnitType.new(id: 3, description: 'Apartamento 3 quartos', metreage: 300, fraction: 3.0,
                               unit_ids: [])
    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return(unit_types)

    login_as admin, scope: :admin
    visit new_condo_base_fee_path(condo.id)
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Valor para Apartamento 1 quarto', with: ''
    fill_in 'Valor para Apartamento 2 quartos', with: ''
    fill_in 'Valor para Apartamento 3 quartos', with: ''
    fill_in 'Data de Emissão', with: ''
    fill_in 'Juros ao dia', with: ''
    fill_in 'Multa por atraso', with: ''
    click_on 'Cadastrar'

    expect(page).to have_content 'Taxa não cadastrada.'
    expect(page).to have_content 'Verifique os erros abaixo:'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Valor não é um número'
    expect(page).to have_content 'Data de Emissão não pode ficar em branco'
    expect(page).to have_content 'Juros ao dia (%) não é um número'
    expect(page).to have_content 'Multa por atraso não é um número'
  end

  it 'e data deve ser futura' do
    admin = create(:admin)
    condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                               unit_ids: [])
    unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quartos', metreage: 200, fraction: 2.0,
                               unit_ids: [])
    unit_types << UnitType.new(id: 3, description: 'Apartamento 3 quartos', metreage: 300, fraction: 3.0,
                               unit_ids: [])
    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return(unit_types)

    formatted_date = 10.days.ago.to_date

    login_as admin, scope: :admin
    visit new_condo_base_fee_path(condo.id)
    fill_in 'Nome', with: 'Taxa de Condomínio'
    fill_in 'Descrição', with: 'Taxas mensais para manutenção do prédio.'
    fill_in 'Valor para Apartamento 1 quarto', with: '200,00'
    fill_in 'Valor para Apartamento 2 quartos', with: '300,00'
    fill_in 'Valor para Apartamento 3 quartos', with: '500,00'
    select 'Semestral', from: 'Recorrência'
    fill_in 'Data de Emissão', with: formatted_date.to_s
    check 'Taxa limitada'
    fill_in 'Juros ao dia', with: 1
    fill_in 'Multa por atraso', with: '30,00'
    click_on 'Cadastrar'

    expect(page).to have_content 'Taxa não cadastrada.'
    expect(page).to have_content 'Data de Emissão deve ser futura'
    expect(page).to have_content 'Número de Parcelas deve estar presente para Taxas Limitadas'
    expect(page).to have_field 'Nome', with: 'Taxa de Condomínio'
    expect(page).to have_field 'Descrição', with: 'Taxas mensais para manutenção do prédio.'
    expect(page).to have_field 'Valor para Apartamento 1 quarto', with: '200,00'
    expect(page).to have_field 'Valor para Apartamento 2 quartos', with: '300,00'
    expect(page).to have_field 'Valor para Apartamento 3 quartos', with: '500,00'
    expect(page).to have_checked_field 'Taxa limitada'
    expect(page).to have_field 'Juros ao dia', with: 1
    expect(page).to have_field 'Multa por atraso', with: '30,00'
  end

  it 'e valor deve ser maior que 0' do
    admin = create(:admin, email: 'admin@email.com', password: '123456')
    condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                               unit_ids: [])
    unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quartos', metreage: 200, fraction: 2.0,
                               unit_ids: [])
    unit_types << UnitType.new(id: 3, description: 'Apartamento 3 quartos', metreage: 300, fraction: 3.0,
                               unit_ids: [])
    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return(unit_types)

    formatted_date = 10.days.from_now.to_date

    login_as admin, scope: :admin
    visit new_condo_base_fee_path(condo)
    fill_in 'Nome', with: 'Taxa de Condomínio'
    fill_in 'Descrição', with: 'Taxas mensais para manutenção do prédio.'
    fill_in 'Valor para Apartamento 1 quarto', with: '0'
    fill_in 'Valor para Apartamento 2 quartos', with: '-200,00'
    fill_in 'Valor para Apartamento 3 quartos', with: '500,00'
    select 'Semestral', from: 'Recorrência'
    fill_in 'Data de Emissão', with: formatted_date.to_s
    fill_in 'Juros ao dia', with: 1
    fill_in 'Multa por atraso', with: '30,00'
    click_on 'Cadastrar'

    expect(page).to have_content 'Taxa não cadastrada.'
    expect(page).to have_content 'Valor deve ser maior que 0', count: 2
  end

  it 'e valor deve ser no formato 0,00' do
    admin = create(:admin, email: 'admin@email.com', password: '123456')
    condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                               unit_ids: [])
    unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quartos', metreage: 200, fraction: 2.0,
                               unit_ids: [])
    unit_types << UnitType.new(id: 3, description: 'Apartamento 3 quartos', metreage: 300, fraction: 3.0,
                               unit_ids: [])
    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(CommonArea).to receive(:all).and_return([])

    formatted_date = 10.days.from_now.to_date

    login_as admin, scope: :admin
    visit new_condo_base_fee_path(condo)
    fill_in 'Nome', with: 'Taxa de Condomínio'
    fill_in 'Descrição', with: 'Taxas mensais para manutenção do prédio.'
    fill_in 'Valor para Apartamento 1 quarto', with: '500quinhentos'
    fill_in 'Valor para Apartamento 2 quartos', with: '200.00'
    fill_in 'Valor para Apartamento 3 quartos', with: 'quinhentos'
    select 'Semestral', from: 'Recorrência'
    fill_in 'Data de Emissão', with: formatted_date.to_s
    fill_in 'Juros ao dia', with: 1
    fill_in 'Multa por atraso', with: '5.5'
    click_on 'Cadastrar'

    expect(page).to have_content 'Taxa não cadastrada.'
    expect(page).to have_content 'Valor deve estar no formato 0,00'
    expect(page).to have_content 'Valor não é um número', count: 2
    expect(page).to have_content 'Multa por atraso deve estar no formato 0,00'
  end

  it 'e retorna para o dashboard do condominio' do
    admin = create(:admin)
    condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                               unit_ids: [])
    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(CommonArea).to receive(:all).and_return([])

    login_as admin, scope: :admin
    visit condo_path(condo.id)
    within 'div#base-fee' do
      click_on 'Adicionar nova'
    end
    find('#arrow-left').click

    expect(current_path).to eq condo_path(condo.id)
  end
end
