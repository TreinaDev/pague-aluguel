class AddStatusToRentFees < ActiveRecord::Migration[7.1]
  def change
    add_column :rent_fees, :status, :integer, default: 0
  end
end
