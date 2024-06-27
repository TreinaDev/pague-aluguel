class RenameTotalValueToTotalValueCents < ActiveRecord::Migration[7.1]
  def change
    rename_column :shared_fees, :total_value, :total_value_cents
  end
end
