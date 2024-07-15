class AddCondoIdToCommonAreaFees < ActiveRecord::Migration[7.1]
  def change
    add_column :common_area_fees, :condo_id, :integer
  end
end
