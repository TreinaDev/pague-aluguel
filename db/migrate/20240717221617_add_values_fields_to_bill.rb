class AddValuesFieldsToBill < ActiveRecord::Migration[7.1]
  def change
    add_column :bills, :shared_fee_value_cents, :integer
    add_column :bills, :base_fee_value_cents, :integer
  end
end
