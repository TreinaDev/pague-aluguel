class AddCommonAreaIdToCommonAreaFees < ActiveRecord::Migration[7.1]
  def change
    add_column :common_area_fees, :common_area_id, :integer
  end
end
