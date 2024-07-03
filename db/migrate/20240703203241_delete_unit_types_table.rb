class DeleteUnitTypesTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :unit_types
  end
end
