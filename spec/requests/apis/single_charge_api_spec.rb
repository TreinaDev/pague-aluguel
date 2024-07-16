require 'rails_helper'

describe 'API de Cobranças Avulsas' do
  context 'POST /api/v1/condos/:id/single_charges' do
    it 'recebe cobrança de taxa de área comum com sucesso' do
      condos = []
      condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
      unit_types = []
      unit_types << UnitType.new(id: 1, area: 40, description: 'Apartamento 1 quarto', ideal_fraction: 0.5, condo_id: 1)
      units = []
      units << Unit.new(id: 1, area: 40, floor: 1, number: 1, unit_type_id: 1)
      common_areas = []
      common_areas << CommonArea.new(id: 1, name: 'Academia',
                                     description: 'Uma academia raíz com ventilador apenas para os marombas',
                                     max_occupancy: 20, rules: 'Não pode ser frango', condo_id: 1)
      allow(Condo).to receive(:all).and_return(condos)
      allow(Condo).to receive(:find).and_return(condos.first)
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(UnitType).to receive(:find).and_return(unit_types.first)
      allow(Unit).to receive(:all).and_return(units)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(CommonArea).to receive(:all).and_return(common_areas)
      allow(CommonArea).to receive(:find).and_return(common_areas.first)

      single_charge_params = { single_charge: { condo_id: condos.first.id, unit_id: units.first.id,
                                                value_cents: 300_00, issue_date: Time.zone.today,
                                                charge_type: :common_area_fee,
                                                common_area_id: common_areas.first.id } }

      post api_v1_single_charges_path, params: single_charge_params

      expect(response.status).to eq 201
      expect(response.body).to include 'Cobrança de Taxa de área comum criada com sucesso.'
      expect(SingleCharge.count).to eq 1
      expect(I18n.t("single_charge.#{SingleCharge.last.charge_type}")).to eq 'Taxa de Área Comum'
    end

    it 'recebe cobrança de taxa de área comum sem o id da área comum' do
      condos = []
      condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
      unit_types = []
      unit_types << UnitType.new(id: 1, area: 40, description: 'Apartamento 1 quarto', ideal_fraction: 0.5, condo_id: 1)
      units = []
      units << Unit.new(id: 1, area: 40, floor: 1, number: 1, unit_type_id: 1)
      allow(Condo).to receive(:all).and_return(condos)
      allow(Condo).to receive(:find).and_return(condos.first)
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(UnitType).to receive(:find).and_return(unit_types.first)
      allow(Unit).to receive(:all).and_return(units)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(CommonArea).to receive(:all).and_return([])

      single_charge_params = { single_charge: { condo_id: condos.first.id, unit_id: units.first.id,
                                                value_cents: 300_00, issue_date: Time.zone.today,
                                                charge_type: :common_area_fee } }

      post api_v1_single_charges_path, params: single_charge_params

      expect(response.status).to eq 422
      expect(response.body).to include 'Área Comum deve ser selecionada'
      expect(SingleCharge.count).to eq 0
    end

    it 'recebe multa com sucesso' do
      condos = []
      condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
      unit_types = []
      unit_types << UnitType.new(id: 1, area: 40, description: 'Apartamento 1 quarto', ideal_fraction: 0.5, condo_id: 1)
      units = []
      units << Unit.new(id: 1, area: 40, floor: 1, number: 1, unit_type_id: 1)
      allow(Condo).to receive(:all).and_return(condos)
      allow(Condo).to receive(:find).and_return(condos.first)
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(UnitType).to receive(:find).and_return(unit_types.first)
      allow(Unit).to receive(:all).and_return(units)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(CommonArea).to receive(:all).and_return([])

      single_charge_params = { single_charge: { condo_id: condos.first.id, unit_id: units.first.id,
                                                value_cents: 300_00, issue_date: Time.zone.today,
                                                description: 'Multa por barulho após as 23h',
                                                charge_type: :fine } }

      post api_v1_single_charges_path, params: single_charge_params

      expect(response.status).to eq 201
      expect(response.body).to include 'Cobrança de Multa criada com sucesso.'
      expect(SingleCharge.count).to eq 1
      expect(SingleCharge.last.description).to eq 'Multa por barulho após as 23h'
    end

    it 'recebe multa com descrição vazia' do
      condos = []
      condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
      unit_types = []
      unit_types << UnitType.new(id: 1, area: 40, description: 'Apartamento 1 quarto', ideal_fraction: 0.5, condo_id: 1)
      units = []
      units << Unit.new(id: 1, area: 40, floor: 1, number: 1, unit_type_id: 1)
      allow(Condo).to receive(:all).and_return(condos)
      allow(Condo).to receive(:find).and_return(condos.first)
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(UnitType).to receive(:find).and_return(unit_types.first)
      allow(Unit).to receive(:all).and_return(units)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(CommonArea).to receive(:all).and_return([])

      single_charge_params = { single_charge: { condo_id: condos.first.id, unit_id: units.first.id,
                                                value_cents: 300_00, issue_date: Time.zone.today,
                                                description: '',
                                                charge_type: :fine } }

      post api_v1_single_charges_path, params: single_charge_params

      expect(response.status).to eq 422
      expect(response.body).to include 'Descrição não pode ficar em branco'
      expect(SingleCharge.count).to eq 0
    end

    it 'recebe multa com data passada' do
      condos = []
      condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
      unit_types = []
      unit_types << UnitType.new(id: 1, area: 40, description: 'Apartamento 1 quarto', ideal_fraction: 0.5, condo_id: 1)
      units = []
      units << Unit.new(id: 1, area: 40, floor: 1, number: 1, unit_type_id: 1)
      allow(Condo).to receive(:all).and_return(condos)
      allow(Condo).to receive(:find).and_return(condos.first)
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(UnitType).to receive(:find).and_return(unit_types.first)
      allow(Unit).to receive(:all).and_return(units)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(CommonArea).to receive(:all).and_return([])

      single_charge_params = { single_charge: { condo_id: condos.first.id, unit_id: units.first.id,
                                                value_cents: 300_00, issue_date: 5.days.ago.to_date,
                                                description: 'Multa por barulho após as 23h',
                                                charge_type: :fine } }

      post api_v1_single_charges_path, params: single_charge_params

      expect(response.status).to eq 422
      expect(response.body).to include 'Data de Emissão deve ser a partir de hoje'
      expect(SingleCharge.count).to eq 0
    end

    it 'recebe multa com id de condomínio errado' do
      condos = []
      condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
      condos << Condo.new(id: 2, name: 'Condo Test 2', city: 'City Test 2')
      unit_types = []
      unit_types << UnitType.new(id: 1, area: 40, description: 'Apartamento 1 quarto', ideal_fraction: 0.5, condo_id: 1)
      units = []
      units << Unit.new(id: 1, area: 40, floor: 1, number: 1, unit_type_id: 1)
      allow(Condo).to receive(:all).and_return(condos)
      allow(Condo).to receive(:find).and_return(condos.first)
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(UnitType).to receive(:find).and_return(unit_types.first)
      allow(Unit).to receive(:all).and_return(units)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(CommonArea).to receive(:all).and_return([])

      single_charge_params = { single_charge: { condo_id: condos.last.id, unit_id: units.first.id,
                                                value_cents: 300_00, issue_date: 5.days.from_now.to_date,
                                                description: 'Multa por barulho após as 23h',
                                                charge_type: :fine } }

      post api_v1_single_charges_path, params: single_charge_params

      expect(response.status).to eq 422
      expect(response.body).to include 'Unidade deve pertencer ao condomínio'
      expect(SingleCharge.count).to eq 0
    end

    it 'recebe multa com id de área comum ' do
      condos = []
      condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
      unit_types = []
      unit_types << UnitType.new(id: 1, area: 40, description: 'Apartamento 1 quarto', ideal_fraction: 0.5, condo_id: 1)
      units = []
      units << Unit.new(id: 1, area: 40, floor: 1, number: 1, unit_type_id: 1)
      common_areas = []
      common_areas << CommonArea.new(id: 1, name: 'Academia',
                                     description: 'Uma academia raíz com ventilador apenas para os marombas',
                                     max_occupancy: 20, rules: 'Não pode ser frango', condo_id: 1)
      allow(Condo).to receive(:all).and_return(condos)
      allow(Condo).to receive(:find).and_return(condos.first)
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(UnitType).to receive(:find).and_return(unit_types.first)
      allow(Unit).to receive(:all).and_return(units)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(CommonArea).to receive(:all).and_return(common_areas)
      allow(CommonArea).to receive(:find).and_return(common_areas.first)

      single_charge_params = { single_charge: { condo_id: condos.first.id, unit_id: units.first.id,
                                                value_cents: 300_00, issue_date: 5.days.from_now.to_date,
                                                description: 'Multa por barulho após as 23h',
                                                charge_type: :fine, common_area_id: common_areas.first.id } }

      post api_v1_single_charges_path, params: single_charge_params

      expect(response.status).to eq 201
      expect(SingleCharge.count).to eq 1
      expect(SingleCharge.last.common_area_id).to eq nil
    end
  end
end
