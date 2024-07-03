class AddCondoIdToCommonAreas < ActiveRecord::Migration[7.1]
  def change
    add_column :common_areas, :condo_id, :integer
  end
end
