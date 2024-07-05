class AddStatusToSharedFees < ActiveRecord::Migration[7.1]
  def change
    add_column :shared_fees, :status, :integer, default: 0
  end
end
