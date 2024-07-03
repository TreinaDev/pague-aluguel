class AddCondoIdToUnitTypes < ActiveRecord::Migration[7.1]
  def change
    add_column :unit_types, :condo_id, :integer
  end
end
