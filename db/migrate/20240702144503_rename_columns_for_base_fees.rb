class RenameColumnsForBaseFees < ActiveRecord::Migration[7.1]
  def change
    rename_column :base_fees, :late_fee, :late_fine_cents
    rename_column :base_fees, :late_payment, :interest_rate
  end
end
