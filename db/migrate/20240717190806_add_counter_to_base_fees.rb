class AddCounterToBaseFees < ActiveRecord::Migration[7.1]
  def change
    add_column :base_fees, :counter, :integer, default: 0
  end
end
