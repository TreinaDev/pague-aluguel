require 'rails_helper'

RSpec.describe Bill, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:issue_date) }
    it { should validate_presence_of(:due_date) }
    it { should validate_presence_of(:total_value_cents) }
    it { should validate_presence_of(:shared_fee_value_cents) }
    it { should validate_presence_of(:base_fee_value_cents) }
    it { should validate_presence_of(:condo_id) }
  end

  describe 'status' do
    it 'deve ser criado por padrão com o status pendente' do
      bill = Bill.new

      expect(bill.status).to eq 'pending'
    end
  end
end
