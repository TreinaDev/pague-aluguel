class AddUnitTypeToUnit < ActiveRecord::Migration[7.1]
  def change
    add_reference :units, :unit_type, null: false, foreign_key: true
  end
end
