class AddStatusToSingleCharges < ActiveRecord::Migration[7.1]
  def change
    add_column :single_charges, :status, :integer, default: 0
  end
end
