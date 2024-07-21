require 'rails_helper'

describe 'Proprietário vê suas unidades' do
  it 'com sucesso' do
    cpf = CPF.generate
    allow(Faraday).to receive(:get).and_return(instance_double('Faraday::Response', success?: true))
    property_owner = create(:property_owner, email: 'propertyownertest@mail.com', password: '123456',
                                             document_number: cpf)

    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    condos << Condo.new(id: 1, name: 'Condo Test 2', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)

    units = []
    units << Unit.new(id: 1, area: 100, floor: 2, number: 3, unit_type_id: 1, owner_name: 'Arthur',
                      tenant_id: 1, owner_id: 1, description: 'Cobertura', condo_name: 'Condo Test')
    units << Unit.new(id: 2, area: 120, floor: 3, number: 4, unit_type_id: 2, owner_name: 'Jules',
                      tenant_id: 2, owner_id: 1, description: 'Apartamento 2 quartos', condo_name: 'Condo Test')
    units << Unit.new(id: 3, area: 130, floor: 4, number: 5, unit_type_id: 3, resident_name: 'Matheus',
                      tenant_id: nil, owner_id: 1, description: 'Apartamento 3 quartos', condo_name: 'Condo Test 2')
    allow(Unit).to receive(:find_all_by_owner).and_return(units)

    login_as property_owner, scope: :property_owner
    visit root_path
    within('div#units') do
      click_on 'Ver todas'
    end

    within('div#all-units') do
      within("div#unit-#{units[0].id}") do
        expect(page).to have_content 'Unidade 3 | Condo Test'
        expect(page).to have_content 'Cobertura'
      end

      within("div#unit-#{units[1].id}") do
        expect(page).to have_content 'Unidade 4 | Condo Test'
        expect(page).to have_content 'Apartamento 2 quartos'
      end

      within("div#unit-#{units[2].id}") do
        expect(page).to have_content 'Unidade 5 | Condo Test'
        expect(page).to have_content 'Apartamento 3 quartos'
      end
    end
  end

  it 'e não possui unidades' do
    cpf = CPF.generate
    allow(Faraday).to receive(:get).and_return(instance_double('Faraday::Response', success?: true))
    property_owner = create(:property_owner, email: 'propertyownertest@mail.com', password: '123456',
                                             document_number: cpf)

    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    condos << Condo.new(id: 1, name: 'Condo Test 2', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)
    allow(Unit).to receive(:find_all_by_owner).and_return([])

    login_as property_owner, scope: :property_owner
    visit root_path

    expect(page).to have_content 'Minhas unidades'
    expect(page).to have_content 'Nenhuma unidade encontrada.'
  end
end
