class AddSingleChargeAndRentFeeToBills < ActiveRecord::Migration[7.1]
  def change
    add_column :bills, :single_charge_value_cents, :integer
    add_column :bills, :rent_fee_cents, :integer
  end
end
