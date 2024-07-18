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
        shared_fee = SharedFee.create(description: 'Descrição', issue_date: 10.days.from_now.to_date,
                                      total_value: 0, condo_id: condo.id)
        allow(Condo).to receive(:find).and_return(condo)
        allow(UnitType).to receive(:all).and_return(unit_types)

        expect(shared_fee.errors.include?(:total_value)).to be true
      end

      it 'verdadeiro quando tudo está preenchido' do
        condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
        unit_types = []
        unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                                   unit_ids: [1])
        shared_fee = SharedFee.create(description: 'Descrição', issue_date: 10.days.from_now.to_date,
                                      total_value: 10_000, condo_id: condo.id)

        allow(Condo).to receive(:find).and_return(condo)
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

describe '.calculate_fractions' do
  it 'divide corretamente as frações' do
    condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 0.525,
                               unit_ids: (1..50).to_a)
    unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quartos', metreage: 100, fraction: 1.346,
                               unit_ids: (51..100).to_a)
    unit_types << UnitType.new(id: 2, description: 'Apartamento duplex', metreage: 100, fraction: 4.023,
                               unit_ids: (101..110).to_a)
    unit_types << UnitType.new(id: 2, description: 'Apartamento com varanda', metreage: 100, fraction: 6.72,
                               unit_ids: (111..120).to_a)
    shared_fee = SharedFee.create(description: 'Descrição', issue_date: 10.days.from_now.to_date,
                                  total_value: 10_000, condo_id: condo.id)
    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return(unit_types)
    shared_fee.calculate_fractions

    expect(SharedFeeFraction.sum(:value_cents)).to eq SharedFee.last.total_value_cents
    (1..30).each do |i|
      expect(SharedFeeFraction.find_by(unit_id: i).value_cents).to eq 26_13
    end
    (31..50).each do |i|
      expect(SharedFeeFraction.find_by(unit_id: i).value_cents).to eq 26_12
    end
    expect(SharedFeeFraction.find_by(unit_id: 51).value_cents).to eq 66_97
    expect(SharedFeeFraction.find_by(unit_id: 101).value_cents).to eq 200_16
    expect(SharedFeeFraction.find_by(unit_id: 111).value_cents).to eq 334_36
  end
end
