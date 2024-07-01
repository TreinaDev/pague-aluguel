class RenameFeeFromCommonAreaFeeHistories < ActiveRecord::Migration[7.1]
  def change
    rename_column :common_area_fee_histories, :fee, :fee_cents
  end
end
