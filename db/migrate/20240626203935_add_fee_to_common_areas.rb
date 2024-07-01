class AddFeeToCommonAreas < ActiveRecord::Migration[7.1]
  def change
    add_column :common_areas, :fee, :integer, default:0
  end
end
