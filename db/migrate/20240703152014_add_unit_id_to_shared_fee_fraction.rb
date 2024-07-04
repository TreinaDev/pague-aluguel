class AddUnitIdToSharedFeeFraction < ActiveRecord::Migration[7.1]
  def change
    add_column :shared_fee_fractions, :unit_id, :integer
  end
end
