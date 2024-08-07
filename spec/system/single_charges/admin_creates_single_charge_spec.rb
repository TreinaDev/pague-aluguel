require 'rails_helper'

describe 'Administrador cria uma cobrança avulsa' do
  it 'com sucesso' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 40, description: 'Apartamento 1 quarto', ideal_fraction: 0.5, condo_id: 1)
    units = []
    units << Unit.new(id: 1, area: 40, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                      condo_name: 'Condo Test', tenant_id: 1, owner_id: 1, description: 'Com varanda')
    common_areas = []
    common_areas << CommonArea.new(id: 1, name: 'Academia',
                                   description: 'Uma academia raíz com ventilador apenas para os marombas',
                                   max_occupancy: 20, rules: 'Não pode ser frango', condo_id: 1)
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(Unit).to receive(:all).and_return(units)
    allow(Unit).to receive(:find).and_return(units.first)
    allow(CommonArea).to receive(:all).and_return(common_areas)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Condo Test'
    within '#single-charge' do
      click_on 'Adicionar nova'
    end

    select 'Outros', from: 'Tipo de Cobrança'
    fill_in 'Descrição', with: 'Acordo entre proprietário e morador'
    select '11', from: 'Unidade'
    fill_in 'Valor', with: '105,59'
    fill_in 'Data de Emissão', with: 5.days.from_now.to_date
    click_on 'Cadastrar'

    expect(page).to have_content 'Cobrança cadastrada com sucesso!'
    expect(page).to have_content 'Outros'
    expect(page).to have_content 'Unidade 11'.downcase
    expect(page).to have_content 'Acordo entre proprietário e morador'.downcase
    expect(page).to have_content 'Data de Emissão'
    expect(page).to have_content I18n.l(5.days.from_now.to_date)
    expect(current_path).to eq condo_path(condos.first.id)
    expect(SingleCharge.first.condo_id).to eq 1
    expect(page).not_to have_content 'Verifique os erros abaixo:'
  end

  it 'e deve estar autenticado' do
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 40, description: 'Apartamento 1 quarto', ideal_fraction: 0.5, condo_id: 1)
    units = []
    units << Unit.new(id: 1, area: 40, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                      condo_name: 'Condo Test', tenant_id: 1, owner_id: 1, description: 'Com varanda')
    units << Unit.new(id: 2, area: 40, floor: 2, number: '21', unit_type_id: 2, condo_id: 1,
                      condo_name: 'Condo Test', tenant_id: 2, owner_id: 2, description: 'Com churrasqueira')
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(Unit).to receive(:all).and_return(units)
    allow(CommonArea).to receive(:all).and_return([])

    visit new_condo_single_charge_path(condos.first.id)

    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
    expect(current_path).to eq new_admin_session_path
  end

  it 'de área comum com sucesso' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 40, description: 'Apartamento 1 quarto', ideal_fraction: 0.5, condo_id: 1)
    units = []
    units << Unit.new(id: 1, area: 40, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                      condo_name: 'Condo Test', tenant_id: 1, owner_id: 1, description: 'Com varanda')
    units << Unit.new(id: 2, area: 40, floor: 2, number: '21', unit_type_id: 2, condo_id: 1,
                      condo_name: 'Condo Test', tenant_id: 2, owner_id: 2, description: 'Com churrasqueira')
    common_areas = []
    common_areas << CommonArea.new(id: 1, name: 'Academia',
                                   description: 'Uma academia raíz com ventilador apenas para os marombas',
                                   max_occupancy: 20, rules: 'Não pode ser frango', condo_id: 1)
    common_areas << CommonArea.new(id: 2, name: 'Churrasqueira',
                                   description: 'Uma área pra assar carnes e linguiça',
                                   max_occupancy: 20, rules: 'Não pode ser frango', condo_id: 1)
    condo = condos.first
    common_area = common_areas.last
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(Unit).to receive(:all).and_return(units)
    allow(Unit).to receive(:find).and_return(units.first)
    allow(CommonArea).to receive(:all).and_return(common_areas)
    allow(CommonArea).to receive(:find).with(common_area.id).and_return(common_area)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Condo Test'
    within '#single-charge' do
      click_on 'Adicionar nova'
    end
    select 'Taxa de Área Comum', from: 'Tipo de Cobrança'
    select 'Churrasqueira', from: 'Área Comum'
    select '11', from: 'Unidade'
    fill_in 'Valor', with: '105,59'
    fill_in 'Data de Emissão', with: 5.days.from_now.to_date
    click_on 'Cadastrar'

    expect(page).to have_content 'Cobrança cadastrada com sucesso'
    expect(page).to have_content 'Unidade 11'.downcase
    expect(page).to have_content 'Taxa de Área Comum'
    expect(page).to have_content 'Data de Emissão'
    expect(page).to have_content I18n.l(5.days.from_now.to_date)
    expect(current_path).to eq condo_path(condos.first.id)
    expect(page).not_to have_content 'Verifique os erros abaixo:'
  end

  it 'botão de voltar' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 40, description: 'Apartamento 1 quarto', ideal_fraction: 0.5, condo_id: 1)
    units = []
    units << Unit.new(id: 1, area: 40, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                      condo_name: 'Condo Test', tenant_id: 1, owner_id: 1, description: 'Com varanda')
    units << Unit.new(id: 2, area: 40, floor: 2, number: '21', unit_type_id: 2, condo_id: 1,
                      condo_name: 'Condo Test', tenant_id: 2, owner_id: 2, description: 'Com churrasqueira')
    condo = condos.first
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(Unit).to receive(:all).and_return(units)
    allow(CommonArea).to receive(:all).and_return([])

    login_as admin, scope: :admin
    visit root_path
    click_on 'Condo Test'
    within '#single-charge' do
      click_on 'Adicionar nova'
    end
    find('#arrow-left').click

    expect(current_path).to eq condo_path(condo.id)
  end

  it 'Mensagens de erro' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 40, description: 'Apartamento 1 quarto', ideal_fraction: 0.5, condo_id: 1)
    units = []
    units << Unit.new(id: 1, area: 40, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                      condo_name: 'Condo Test', tenant_id: 1, owner_id: 1, description: 'Com varanda')
    units << Unit.new(id: 2, area: 40, floor: 2, number: '21', unit_type_id: 2, condo_id: 1,
                      condo_name: 'Condo Test', tenant_id: 2, owner_id: 2, description: 'Com churrasqueira')
    common_areas = []
    common_areas << CommonArea.new(id: 1, name: 'Academia',
                                   description: 'Uma academia raíz com ventilador apenas para os marombas',
                                   max_occupancy: 20, rules: 'Não pode ser frango', condo_id: 1)
    condo = condos.first
    common_area = common_areas.last
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(Unit).to receive(:all).and_return(units)
    allow(CommonArea).to receive(:all).and_return(common_areas)
    allow(CommonArea).to receive(:find).with(common_area.id).and_return(common_area)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Condo Test'
    within '#single-charge' do
      click_on 'Adicionar nova'
    end
    fill_in 'Descrição', with: ''
    select '', from: 'Unidade'
    fill_in 'Valor', with: ''
    fill_in 'Data de Emissão', with: ''
    click_on 'Cadastrar'

    expect(page).to have_content 'Não foi possível cadastrar a cobrança.'
    expect(page).to have_content 'Verifique os erros abaixo:'
    expect(page).to have_content 'Unidade não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Valor Total não é um número'
    expect(page).to have_content 'Data de Emissão não pode ficar em branco'
    expect(page).not_to have_content 'Tipo de Cobrança não pode ficar em branco'
    expect(page).not_to have_content 'Área Comum deve ser selecionada'
  end

  it 'e deve selecionar área comum para taxa de área comum' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 40, description: 'Apartamento 1 quarto', ideal_fraction: 0.5, condo_id: 1)
    units = []
    units << Unit.new(id: 1, area: 40, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                      condo_name: 'Condo Test', tenant_id: 1, owner_id: 1, description: 'Com varanda')
    units << Unit.new(id: 2, area: 40, floor: 1, number: '12', unit_type_id: 2, condo_id: 1,
                      condo_name: 'Condo Test', tenant_id: 2, owner_id: 2, description: 'Com churrasqueira')
    common_areas = []
    common_areas << CommonArea.new(id: 1, name: 'Academia',
                                   description: 'Uma academia raíz com ventilador apenas para os marombas',
                                   max_occupancy: 20, rules: 'Não pode ser frango', condo_id: 1)
    condo = condos.first
    common_area = common_areas.last
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(Unit).to receive(:all).and_return(units)
    allow(Unit).to receive(:find).and_return(units.first)
    allow(CommonArea).to receive(:all).and_return(common_areas)
    allow(CommonArea).to receive(:find).with(common_area.id).and_return(common_area)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Condo Test'
    within '#single-charge' do
      click_on 'Adicionar nova'
    end
    select 'Taxa de Área Comum', from: 'Tipo de Cobrança'
    select '12', from: 'Unidade'
    fill_in 'Valor', with: '105,59'
    fill_in 'Data de Emissão', with: 5.days.from_now.to_date
    click_on 'Cadastrar'

    expect(page).to have_content 'Não foi possível cadastrar a cobrança.'
    expect(page).to have_content 'Verifique os erros abaixo:'
    expect(page).to have_content 'Área Comum deve ser selecionada'
    expect(page).not_to have_content 'Unidade não pode ficar em branco'
    expect(page).not_to have_content 'Descrição não pode ficar em branco'
    expect(page).not_to have_content 'Valor Total não é um número'
    expect(page).not_to have_content 'Data de Emissão não pode ficar em branco'
    expect(page).not_to have_content 'Tipo de Cobrança não pode ficar em branco'
  end

  it 'e não há área comum cadastrada' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 40, description: 'Apartamento 1 quarto', ideal_fraction: 0.5, condo_id: 1)
    units = []
    units << Unit.new(id: 1, area: 40, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                      condo_name: 'Condo Test', tenant_id: 1, owner_id: 1, description: 'Com varanda')
    units << Unit.new(id: 2, area: 40, floor: 2, number: '21', unit_type_id: 2, condo_id: 1,
                      condo_name: 'Condo Test', tenant_id: 2, owner_id: 2, description: 'Com churrasqueira')
    condo = condos.first
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(Unit).to receive(:all).and_return(units)
    allow(CommonArea).to receive(:all).and_return([])

    login_as admin, scope: :admin
    visit root_path
    click_on 'Condo Test'
    within '#single-charge' do
      click_on 'Adicionar nova'
    end

    expect(page).to have_select('Tipo de Cobrança', options: %w[Outros Multa])
    expect(page).not_to have_select('Tipo de Cobrança', options: ['Taxa de Área Comum'])
  end
end
