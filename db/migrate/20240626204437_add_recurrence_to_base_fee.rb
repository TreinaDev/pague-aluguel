class AddRecurrenceToBaseFee < ActiveRecord::Migration[7.1]
  def change
    add_column :base_fees, :recurrence, :integer, default: 0
  end
end
