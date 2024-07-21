require 'rails_helper'

RSpec.describe BillDetail, type: :model do
  it { should validate_numericality_of(:value).is_greater_than_or_equal_to(0) }
  it { should belong_to(:bill) }
end
