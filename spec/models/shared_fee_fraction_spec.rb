require 'rails_helper'

RSpec.describe SharedFeeFraction, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:value) }
    it { should validate_presence_of(:shared_fee) }
    it { should validate_presence_of(:unit) }
    it { should belong_to(:shared_fee) }
    it { should belong_to(:unit) }
  end
end
