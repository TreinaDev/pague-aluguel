class AddUnitTypeIdToUnit < ActiveRecord::Migration[7.1]
  def change
    add_column :units, :unit_type_id, :integer
  end
end
