class AddStatusToBaseFees < ActiveRecord::Migration[7.1]
  def change
    add_column :base_fees, :status, :integer, default: 0
  end
end
