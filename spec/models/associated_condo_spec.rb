require 'rails_helper'

RSpec.describe AssociatedCondo, type: :model do
  describe 'validacoes' do
    it { should validate_presence_of(:condo_id) }
    it { should belong_to(:admin) }
  end
end
