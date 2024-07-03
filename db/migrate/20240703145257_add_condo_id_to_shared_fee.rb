class AddCondoIdToSharedFee < ActiveRecord::Migration[7.1]
  def change
    add_column :shared_fees, :condo_id, :integer
  end
end
