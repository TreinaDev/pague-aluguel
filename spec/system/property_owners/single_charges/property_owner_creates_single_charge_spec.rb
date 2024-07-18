require 'rails_helper'

describe 'Proprietario cria cobrança avulsa' do
  it 'com sucesso' do
    cpf = CPF.generate
    allow(Faraday).to receive(:get).and_return(instance_double('Faraday::Response', success?: true))
    property_owner = create(:property_owner, email: 'propertyownertest@mail.com', password: '123456',
                                             document_number: cpf)

    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos[0])

    units = []
    units << Unit.new(id: 2, area: 120, floor: 3, number: 44, unit_type_id: 2, owner_name: 'Jules',
                      tenant_id: 2, owner_id: 1, condo_id: 1, description: 'Apartamento 2 quartos',
                      condo_name: 'Condo Test')
    allow(Unit).to receive(:find_all_by_owner).and_return(units)
    allow(Unit).to receive(:find).and_return(units[0])
    allow(Unit).to receive(:all).and_return(units)

    login_as property_owner, scope: :property_owner
    visit root_path

    click_on 'Adicionar nova'
    select 'Apartamento 2 quartos - 44', from: 'Unidade'
    select 'Outros', from: 'Tipo de Cobrança'
    fill_in 'Descrição', with: 'Acordo entre proprietário e morador'
    fill_in 'Valor', with: '105,59'
    fill_in 'Data de Emissão', with: 5.days.from_now.to_date
    click_on 'Cadastrar'

    expect(page).to have_content 'Cobrança Avulsa cadastrada com sucesso!'
    expect(current_path).to eq owners_single_charges_path
    expect(page).to have_content 'Outros'
    expect(page).to have_content 'Acordo entre proprietário e morador'
    expect(page).to have_content 'Data de Emissão'
    expect(page).to have_content I18n.l(5.days.from_now.to_date)
  end

  it 'e falha quando campos estao vazios' do
    cpf = CPF.generate
    allow(Faraday).to receive(:get).and_return(instance_double('Faraday::Response', success?: true))
    property_owner = create(:property_owner, email: 'propertyownertest@mail.com', password: '123456',
                                             document_number: cpf)

    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos[0])

    units = []
    units << Unit.new(id: 2, area: 120, floor: 3, number: 44, unit_type_id: 2, owner_name: 'Jules',
                      tenant_id: 2, owner_id: 1, condo_id: 1, description: 'Apartamento 2 quartos',
                      condo_name: 'Condo Test')
    allow(Unit).to receive(:find_all_by_owner).and_return(units)
    allow(Unit).to receive(:find).and_return(units[0])
    allow(Unit).to receive(:all).and_return(units)

    login_as property_owner, scope: :property_owner
    visit root_path

    click_on 'Adicionar nova'
    fill_in 'Descrição', with: ''
    fill_in 'Valor', with: ''
    fill_in 'Data de Emissão', with: ''
    click_on 'Cadastrar'

    expect(page).to have_content 'Unidade não pode ficar em branco'
    expect(page).to have_content 'Data de Emissão não pode ficar em branco'
    expect(page).to have_content 'Valor Total não é um número'
    expect(page).to have_content 'Descrição não pode ficar em branco'
  end

  it 'e deve estar autenticado' do
    visit new_owners_single_charge_path

    expect(current_path).not_to eq new_owners_single_charge_path
    expect(current_path).to eq new_property_owner_session_path
  end
end
