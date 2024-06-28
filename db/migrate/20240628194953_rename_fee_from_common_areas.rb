class RenameFeeFromCommonAreas < ActiveRecord::Migration[7.1]
  def change
    rename_column :common_areas, :fee, :fee_cents
  end
end
