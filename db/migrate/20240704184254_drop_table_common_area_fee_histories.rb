class DropTableCommonAreaFeeHistories < ActiveRecord::Migration[7.1]
  def change
    drop_table :common_area_fee_histories
  end
end
