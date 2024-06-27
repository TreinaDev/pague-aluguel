class RenameValueToValueCents < ActiveRecord::Migration[7.1]
  def change
    rename_column :shared_fee_fractions, :value, :value_cents
  end
end
