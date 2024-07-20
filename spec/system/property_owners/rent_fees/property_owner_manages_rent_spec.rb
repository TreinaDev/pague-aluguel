require 'rails_helper'

describe 'Proprietário configura aluguel' do
  it 'com sucesso' do
    cpf = CPF.generate
    allow(Faraday).to receive(:get).and_return(instance_double('Faraday::Response', success?: true))
    property_owner = create(:property_owner, email: 'propertyownertest@mail.com', password: '123456',
                                             document_number: cpf)

    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)

    units = []
    units << Unit.new(id: 2, area: 120, floor: 3, number: 4, unit_type_id: 2, owner_name: 'Jules',
                      tenant_id: 2, owner_id: 1, condo_id: 1, description: 'Apartamento 2 quartos',
                      condo_name: 'Condo Test')
    allow(Unit).to receive(:find_all_by_owner).and_return(units)
    allow(Unit).to receive(:find).and_return(units[0])

    login_as property_owner, scope: :property_owner
    visit unit_path(2)
    click_on 'Configurar Aluguel'
    fill_in 'Valor do aluguel', with: '1200,00'
    fill_in 'Data de Emissão', with: 2.days.from_now.to_date
    fill_in 'Multa por atraso', with: '50,00'
    fill_in 'Juros por atraso ao mês (em %)', with: 10
    click_on 'Atualizar'

    expect(page).to have_content 'Taxa cadastrada com sucesso!'
    expect(current_path).to eq unit_path(2)
    expect(RentFee.last.owner_id).to eq 1
    within 'div#unit-modal' do
      expect(page).to have_content 'Aluguel'
      expect(page).to have_content 'R$1.200,00'
      expect(page).to have_content 'data de emissão'
      expect(page).to have_content I18n.l(2.days.from_now.to_date)
      expect(page).to have_content 'multa por atraso'
      expect(page).to have_content 'R$50,00'
      expect(page).to have_content 'juros por atraso ao mês'
      expect(page).to have_content '10.0%'
    end
  end

  it 'e atualiza aluguel já existente' do
    cpf = CPF.generate
    allow(Faraday).to receive(:get).and_return(instance_double('Faraday::Response', success?: true))
    property_owner = create(:property_owner, email: 'propertyownertest@mail.com', password: '123456',
                                             document_number: cpf)

    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)

    units = []
    units << Unit.new(id: 2, area: 120, floor: 3, number: 4, unit_type_id: 2, owner_name: 'Jules',
                      tenant_id: 2, owner_id: 1, condo_id: 1, description: 'Apartamento 2 quartos',
                      condo_name: 'Condo Test')
    allow(Unit).to receive(:find_all_by_owner).and_return(units)
    allow(Unit).to receive(:find).and_return(units[0])
    RentFee.create!(owner_id: 1, tenant_id: 2, unit_id: 2, value_cents: 120_000, issue_date: 2.days.from_now.to_date,
                    fine_cents: 5000, fine_interest: 10, condo_id: 1)

    login_as property_owner, scope: :property_owner
    visit unit_path(2)
    click_on 'Configurar Aluguel'
    fill_in 'Valor do aluguel', with: '1400,00'
    click_on 'Atualizar'

    expect(page).to have_content 'Aluguel atualizado com sucesso!'
    expect(current_path).to eq unit_path(2)
    expect(RentFee.last.owner_id).to eq 1
    within 'div#unit-modal' do
      expect(page).to have_content 'Aluguel'
      expect(page).to have_content 'R$1.400,00'
      expect(page).to have_content 'data de emissão'
      expect(page).to have_content I18n.l(2.days.from_now.to_date)
      expect(page).to have_content 'multa por atraso'
      expect(page).to have_content 'R$50,00'
      expect(page).to have_content 'juros por atraso ao mês'
      expect(page).to have_content '10.0%'
    end
  end

  it 'tenta configurar aluguel e deixa campos obrigatórios em branco' do
    cpf = CPF.generate
    allow(Faraday).to receive(:get).and_return(instance_double('Faraday::Response', success?: true))
    property_owner = create(:property_owner, email: 'propertyownertest@mail.com', password: '123456',
                                             document_number: cpf)

    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)

    units = []
    units << Unit.new(id: 2, area: 120, floor: 3, number: 4, unit_type_id: 2, owner_name: 'Jules',
                      tenant_id: 2, owner_id: 1, condo_id: 1, description: 'Apartamento 2 quartos',
                      condo_name: 'Condo Test')
    allow(Unit).to receive(:find_all_by_owner).and_return(units)
    allow(Unit).to receive(:find).and_return(units[0])

    login_as property_owner, scope: :property_owner
    visit unit_path(2)
    click_on 'Configurar Aluguel'
    click_on 'Atualizar'

    expect(page).to have_content 'Valor do aluguel não é um número'
    expect(page).to have_content 'Data de Emissão não pode ficar em branco'
    expect(page).to have_content 'Multa por atraso não é um número'
    expect(page).to have_content 'Juros por atraso ao mês (em %) não pode ficar em branco'
  end

  it 'tenta configurar aluguel e deixa campos obrigatórios em branco' do
    cpf = CPF.generate
    allow(Faraday).to receive(:get).and_return(instance_double('Faraday::Response', success?: true))
    property_owner = create(:property_owner, email: 'propertyownertest@mail.com', password: '123456',
                                             document_number: cpf)

    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)

    units = []
    units << Unit.new(id: 2, area: 120, floor: 3, number: 4, unit_type_id: 2, owner_name: 'Jules',
                      tenant_id: 2, owner_id: 1, condo_id: 1, description: 'Apartamento 2 quartos',
                      condo_name: 'Condo Test')
    create(:rent_fee, unit_id: units[0].id)

    allow(Unit).to receive(:find_all_by_owner).and_return(units)
    allow(Unit).to receive(:find).and_return(units[0])

    login_as property_owner, scope: :property_owner
    visit unit_path(2)
    click_on 'Configurar Aluguel'
    fill_in 'Valor do aluguel', with: ''
    fill_in 'Data de Emissão', with: ''
    fill_in 'Multa por atraso', with: ''
    fill_in 'Juros por atraso ao mês (em %)', with: ''
    click_on 'Atualizar'

    expect(page).to have_content 'Valor do aluguel não é um número'
    expect(page).to have_content 'Data de Emissão não pode ficar em branco'
    expect(page).to have_content 'Multa por atraso não é um número'
    expect(page).to have_content 'Juros por atraso ao mês (em %) não pode ficar em branco'
  end

  it 'e visualiza aluguel já existente' do
    cpf = CPF.generate
    allow(Faraday).to receive(:get).and_return(instance_double('Faraday::Response', success?: true))
    property_owner = create(:property_owner, email: 'propertyownertest@mail.com', password: '123456',
                                             document_number: cpf)

    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)

    units = []
    units << Unit.new(id: 2, area: 120, floor: 3, number: 4, unit_type_id: 2, owner_name: 'Jules', condo_id: 1,
                      tenant_id: 2, owner_id: 1, description: 'Apartamento 2 quartos', condo_name: 'Condo Test')
    allow(Unit).to receive(:find_all_by_owner).and_return(units)
    allow(Unit).to receive(:find).and_return(units[0])
    RentFee.create!(owner_id: 1, tenant_id: 2, unit_id: 2, value_cents: 120_000, issue_date: 2.days.from_now.to_date,
                    fine_cents: 5000, fine_interest: 10, condo_id: 1)

    login_as property_owner, scope: :property_owner
    visit unit_path(2)

    within 'div#unit-modal' do
      expect(page).to have_content 'Aluguel'
      expect(page).to have_content 'R$1.200,00'
      expect(page).to have_content 'data de emissão'
      expect(page).to have_content I18n.l(2.days.from_now.to_date)
      expect(page).to have_content 'multa por atraso'
      expect(page).to have_content 'R$50,00'
      expect(page).to have_content 'juros por atraso ao mês'
      expect(page).to have_content '10.0%'
    end
  end

  it 'e tenta acessar página de configuração de aluguel de unidade que não é sua' do
    cpf = CPF.generate
    allow(Faraday).to receive(:get).and_return(instance_double('Faraday::Response', success?: true))
    property_owner = create(:property_owner, email: 'propertyownertest@mail.com', password: '123456',
                                             document_number: cpf)
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)
    units = []
    units << Unit.new(id: 3, area: 120, floor: 3, number: 4, unit_type_id: 2, owner_name: 'Jules',
                      tenant_id: 2, owner_id: property_owner.id, description: 'Apartamento 2 quartos',
                      condo_name: 'Condo Test', condo_id: 1)

    unit = Unit.new(id: 20, area: 120, floor: 3, number: 4, unit_type_id: 2, owner_name: 'Jules',
                    tenant_id: 2, owner_id: 100, description: 'Apartamento 2 quartos',
                    condo_name: 'Condo Test')

    rent_fee = create(:rent_fee, unit_id: unit.id)
    allow(Unit).to receive(:find_all_by_owner).and_return(units)
    allow(Unit).to receive(:find).and_return(unit)

    login_as property_owner, scope: :property_owner
    visit edit_unit_rent_fee_path(unit.id, rent_fee.id)

    expect(page).to have_content('Você não tem permissão para acessar essa página')
    expect(current_path).to eq root_path
  end

  it 'e desativa cobrança do aluguel da unidade' do
    cpf = CPF.generate
    allow(Faraday).to receive(:get).and_return(instance_double('Faraday::Response', success?: true))
    property_owner = create(:property_owner, email: 'propertyownertest@mail.com', password: '123456',
                                             document_number: cpf)
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)
    units = []
    units << Unit.new(id: 2, area: 120, floor: 3, number: 4, unit_type_id: 2, owner_name: 'Jules', condo_id: 1,
                      tenant_id: nil, owner_id: 1, description: 'Apartamento 2 quartos', condo_name: 'Condo Test')
    allow(Unit).to receive(:find_all_by_owner).and_return(units)
    allow(Unit).to receive(:find).and_return(units[0])
    RentFee.create!(owner_id: 1, tenant_id: 2, unit_id: 2, value_cents: 120_000, issue_date: 2.days.from_now.to_date,
                    fine_cents: 5000, fine_interest: 10, condo_id: 1)

    login_as property_owner, scope: :property_owner
    visit unit_path(2)
    accept_confirm do
      click_on 'Desativar Cobrança'
    end

    expect(page).to have_content 'Aluguel desativado com sucesso!'
    within 'div#unit-modal' do
      expect(page).to have_content 'Esta unidade está disponível para locação'
      expect(page).to have_content 'status da cobrança'
      expect(page).to have_content 'Desativado'
      expect(page).not_to have_content 'DESATIVAR COBRANÇA'
    end
  end
end
