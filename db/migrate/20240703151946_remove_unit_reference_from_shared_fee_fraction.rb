class RemoveUnitReferenceFromSharedFeeFraction < ActiveRecord::Migration[7.1]
  def change
    remove_reference :shared_fee_fractions, :unit, null: false, foreign_key: true
  end
end
