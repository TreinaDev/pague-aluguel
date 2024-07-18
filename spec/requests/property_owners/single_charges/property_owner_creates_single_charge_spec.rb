require 'rails_helper'

describe 'Proprietario cria cobrança avulsa' do
  it 'e falha se tenta criar para uma unidade que não é sua' do
    cpf = CPF.generate
    allow(Faraday).to receive(:get).and_return(instance_double('Faraday::Response', success?: true))
    property_owner = create(:property_owner, email: 'propertyownertest@mail.com', password: '123456',
                                             document_number: cpf)

    property_owner2 = create(:property_owner, email: 'impostor@mail.com', password: '123456',
                                              document_number: CPF.generate)

    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos[0])

    units = []
    units << Unit.new(id: 2, area: 120, floor: 3, number: 44, unit_type_id: 2, owner_name: 'Jules',
                      tenant_id: 2, owner_id: property_owner2.id, condo_id: 1, description: 'Apartamento 2 quartos',
                      condo_name: 'Condo Test')
    allow(Unit).to receive(:find_all_by_owner).and_return([])
    allow(Unit).to receive(:find).and_return(units[0])
    allow(Unit).to receive(:all).and_return(units)

    login_as property_owner, scope: :property_owner

    post owners_single_charges_path, params: {
      single_charge: {
        description: 'Multa',
        value: 5000,
        unit_id: units[0].id,
        charge_type: :other,
        issue_date: Time.zone.today
      }
    }

    expect(response).to redirect_to root_path
    expect(response.status).to eq 302
  end
end
