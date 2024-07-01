class RemoveValueFromBaseFee < ActiveRecord::Migration[7.1]
  def change
    remove_column :base_fees, :value
    add_column :values, :price, :integer
  end
end
