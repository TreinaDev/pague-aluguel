require 'rails_helper'

RSpec.describe CommonAreaFee, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:value_cents) }
    it { should belong_to(:admin) }
    it { should validate_numericality_of(:value).is_greater_than_or_equal_to(0) }
  end
end