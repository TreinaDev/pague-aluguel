require 'rails_helper'

RSpec.describe SharedFee, type: :model do
  describe 'valido?' do
    context 'presente' do
      it 'falso quando qualquer campo está vazio' do
        condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
        shared_fee = SharedFee.create(description: '', issue_date: nil,
                                      total_value: '', condo_id: nil)
        allow(Condo).to receive(:find).and_return(condo)

        expect(shared_fee.errors.include?(:description)).to be true
        expect(shared_fee.errors.include?(:issue_date)).to be true
        expect(shared_fee.errors.include?(:total_value)).to be true
        expect(shared_fee.errors.include?(:condo_id)).to be true
      end

      it 'falso quando o total_value é 0' do
        condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
        unit_types = []
        unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                                   unit_ids: [1])
        units = []
        units << Unit.new(id: 1, area: 100, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                          condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 1, description: 'Com varanda')
        shared_fee = SharedFee.create(description: 'Descrição', issue_date: 10.days.from_now.to_date,
                                      total_value: 0, condo_id: condo.id)
        allow(Condo).to receive(:find).and_return(condo)
        allow(Unit).to receive(:all).and_return(units)
        allow(UnitType).to receive(:all).and_return(unit_types)

        expect(shared_fee.errors.include?(:total_value)).to be true
      end

      it 'verdadeiro quando tudo está preenchido' do
        condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
        unit_types = []
        unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                                   unit_ids: [1])
        units = []
        units << Unit.new(id: 1, area: 100, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                          condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 1, description: 'Com varanda')
        shared_fee = SharedFee.create(description: 'Descrição', issue_date: 10.days.from_now.to_date,
                                      total_value: 10_000, condo_id: condo.id)

        allow(Condo).to receive(:find).and_return(condo)
        allow(Unit).to receive(:all).and_return(units)
        allow(UnitType).to receive(:all).and_return(unit_types)

        expect(shared_fee.errors.include?(:description)).to be false
        expect(shared_fee.errors.include?(:issue_date)).to be false
        expect(shared_fee.errors.include?(:total_value)).to be false
        expect(shared_fee.errors.include?(:condo_id)).to be false
      end
    end

    context 'data' do
      it 'falso quando a data está no passado' do
        condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
        shared_fee = SharedFee.create(description: 'Descrição', issue_date: 10.days.ago.to_date,
                                      total_value: 10_000, condo_id: condo.id)
        allow(Condo).to receive(:find).and_return(condo)

        expect(shared_fee.errors.full_messages).to include('Data de Emissão deve ser a partir de hoje.')
      end

      it 'verdadeiro quando a data está no futuro' do
        condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
        shared_fee = SharedFee.create(description: 'Descrição', issue_date: 10.days.from_now.to_date,
                                      total_value: 10_000, condo_id: condo.id)
        allow(Condo).to receive(:find).and_return(condo)

        expect(shared_fee.errors.include?(:issue_date)).to be false
      end

      it 'verdadeiro quando a data é hoje' do
        condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
        shared_fee = SharedFee.create(description: 'Descrição', issue_date: Time.zone.today,
                                      total_value: 10_000, condo_id: condo.id)
        allow(Condo).to receive(:find).and_return(condo)

        expect(shared_fee.errors.include?(:issue_date)).to be false
      end
    end

    it { should have_many(:shared_fee_fractions) }
  end
end
