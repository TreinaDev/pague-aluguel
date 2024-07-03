class AddCondoToBaseFees < ActiveRecord::Migration[7.1]
  def change
    add_column :base_fees, :condo_id, :integer
  end
end
