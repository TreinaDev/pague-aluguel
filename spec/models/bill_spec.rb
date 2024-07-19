require 'rails_helper'

RSpec.describe Bill, type: :model do
  describe 'validations' do
    it { should have_one(:receipt) }
    it { should validate_presence_of(:issue_date) }
    it { should validate_presence_of(:due_date) }
    it { should validate_numericality_of(:total_value).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:shared_fee_value).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:base_fee_value).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:single_charge_value).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:rent_fee).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:condo_id) }
  end

  describe 'status' do
    it 'deve ser criado por padrão com o status pendente' do
      bill = Bill.new

      expect(bill.status).to eq 'pending'
    end
  end
end
