class RemoveUnitTypeReferenceFromValues < ActiveRecord::Migration[7.1]
  def change
    remove_reference :values, :unit_type, null: false, foreign_key: true
  end
end
