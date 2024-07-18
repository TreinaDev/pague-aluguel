require 'rails_helper'

describe 'Proprietario ve lista de cobranças avulsas criadas por ele em suas unidades' do
  it 'com sucesso' do
    cpf = CPF.generate
    allow(Faraday).to receive(:get).and_return(instance_double('Faraday::Response', success?: true))
    property_owner = create(:property_owner, email: 'propertyownertest@mail.com', password: '123456',
                                             document_number: cpf)

    condos = []
    condos << Condo.new(id: 1, name: 'Sai de Baixo', city: 'City Test')
    condos << Condo.new(id: 2, name: 'Portobelo', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos[0], condos[1])

    units = []
    units << Unit.new(id: 1, area: 120, floor: 3, number: 44, unit_type_id: 2, owner_name: 'Jules',
                      tenant_id: 2, owner_id: 1, condo_id: 1, description: 'Apartamento 2 quartos',
                      condo_name: 'Sai de Baixo')
    units << Unit.new(id: 2, area: 120, floor: 3, number: 55, unit_type_id: 2, owner_name: 'Jules',
                      tenant_id: 2, owner_id: 1, condo_id: 2, description: 'Apartamento 3 quartos',
                      condo_name: 'Portobelo')

    allow(Unit).to receive(:find_all_by_owner).and_return(units)
    allow(Unit).to receive(:find).and_return(units[0], units[1])
    allow(Unit).to receive(:all).and_return(units)

    create(:single_charge, unit_id: units[0].id, description: 'Multa por barulho', value_cents: 5_000)
    create(:single_charge, unit_id: units[1].id, description: 'Multa por danos ao condomínio', value_cents: 10_000)

    login_as property_owner, scope: :property_owner
    visit owners_single_charges_path

    expect(page).to have_content 'Unidade 44'
    expect(page).to have_content 'Sai de Baixo'
    expect(page).to have_content 'Multa por barulho'
    expect(page).to have_content 'R$50,00'

    expect(page).to have_content 'Unidade 55'
    expect(page).to have_content 'Portobelo'
    expect(page).to have_content 'Multa por danos ao condomínio'
    expect(page).to have_content 'R$100,00'
  end

  it 'ordenado pelo mais recente' do
    cpf = CPF.generate
    allow(Faraday).to receive(:get).and_return(instance_double('Faraday::Response', success?: true))
    property_owner = create(:property_owner, email: 'propertyownertest@mail.com', password: '123456',
                                             document_number: cpf)

    condos = []
    condos << Condo.new(id: 1, name: 'Sai de Baixo', city: 'City Test')
    condos << Condo.new(id: 2, name: 'Portobelo', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos[1], condos[0])

    units = []
    units << Unit.new(id: 1, area: 120, floor: 3, number: 44, unit_type_id: 2, owner_name: 'Jules',
                      tenant_id: 2, owner_id: 1, condo_id: 1, description: 'Apartamento 2 quartos',
                      condo_name: 'Sai de Baixo')
    units << Unit.new(id: 2, area: 120, floor: 3, number: 55, unit_type_id: 2, owner_name: 'Jules',
                      tenant_id: 2, owner_id: 1, condo_id: 2, description: 'Apartamento 3 quartos',
                      condo_name: 'Portobelo')

    allow(Unit).to receive(:find_all_by_owner).and_return(units)
    allow(Unit).to receive(:find).and_return(units[1])
    allow(Unit).to receive(:all).and_return(units)

    create(:single_charge, unit_id: 1, description: 'Multa por barulho', value_cents: 5_000,
                           created_at: 3.days, condo_id: 1)
    create(:single_charge, unit_id: 2, description: 'Multa por danos ao condomínio', value_cents: 10_000,
                           created_at: 1.day, condo_id: 2)

    login_as property_owner, scope: :property_owner
    visit owners_single_charges_path

    within('div#single-charge-0') do
      expect(page).to have_content 'Multa por danos ao condomínio'
      expect(page).to have_content 'Portobelo'
      expect(page).to have_content 'R$100,00'
      expect(page).to have_content 'Unidade 55'

      expect(page).not_to have_content 'Unidade 44'
      expect(page).not_to have_content 'Sai de Baixo'
      expect(page).not_to have_content 'Multa por barulho'
      expect(page).not_to have_content 'R$50,00'
    end
  end
end
