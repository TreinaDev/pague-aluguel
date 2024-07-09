class DropCustomFees < ActiveRecord::Migration[7.1]
  def change
    drop_table :custom_fees
  end
end
