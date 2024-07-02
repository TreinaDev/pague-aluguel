class AddUnitTypeIdToValues < ActiveRecord::Migration[7.1]
  def change
    add_column :values, :unit_type_id, :integer
  end
end
