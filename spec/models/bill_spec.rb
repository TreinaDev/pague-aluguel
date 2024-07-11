require 'rails_helper'

RSpec.describe Bill, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:issue_date) }
    it { should validate_presence_of(:due_date) }
    it { should validate_presence_of(:total_value_cents) }
  end
end
