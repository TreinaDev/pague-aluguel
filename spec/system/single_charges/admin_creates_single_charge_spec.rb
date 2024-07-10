require 'rails_helper'

describe 'Administrador cria uma cobrança avulsa' do
  it 'com sucesso' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 40, description: 'Apartamento 1 quarto', ideal_fraction: 0.5, condo_id: 1)
    units = []
    units << Unit.new(id: 1, area: 40, floor: 1, number: 1, unit_type_id: 1)
    units << Unit.new(id: 2, area: 40, floor: 1, number: 1, unit_type_id: 1)
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(Unit).to receive(:all).and_return(units)
    allow(CommonArea).to receive(:all).and_return([])

    login_as admin, scope: :admin
    visit root_path
    click_on 'Condo Test'
    click_on 'Lançar Cobrança Avulsa'
    select 'Outros', from: 'Tipo de Cobrança'
    fill_in 'Descrição', with: 'Acordo entre proprietário e morador'
    fill_in 'Unidade', with: units.last.id
    fill_in 'Valor', with: '105,59'
    fill_in 'Data de Emissão', with: 5.days.from_now.to_date
    click_on 'Cadastrar'

    expect(page).to have_content 'Cobrança Avulsa cadastrada com sucesso'
    expect(page).to have_content 'Descrição'
    expect(page).to have_content 'Acordo entre proprietário e morador'
    expect(page).to have_content 'Valor'
    expect(page).to have_content 'R$105,59'
    expect(page).to have_content 'Data de Emissão'
    expect(page).to have_content I18n.l(5.days.from_now.to_date)
    expect(current_path).to eq condo_single_charge_path(condos.first.id, SingleCharge.last)
  end

  xit 'botão de voltar' do
    
  end

  xit 'Mensagens de erro' do
    
end
end
