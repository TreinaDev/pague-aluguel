class DeleteStatusFromBills < ActiveRecord::Migration[7.1]
  def change
    remove_column :bills, :status, :integer
  end
end
