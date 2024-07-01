class RemoveFeeFromCommonAreas < ActiveRecord::Migration[7.1]
  def change
    remove_column :common_areas, :fee
  end
end
