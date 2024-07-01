class AddColumnsToBaseFee < ActiveRecord::Migration[7.1]
  def change
    add_column :base_fees, :name, :string
    add_column :base_fees, :late_payment, :integer
    add_column :base_fees, :late_fee, :integer
    add_column :base_fees, :fixed, :boolean
    add_column :base_fees, :charge_day, :date
  end
end
