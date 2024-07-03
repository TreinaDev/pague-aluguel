class RemovePriceFromValues < ActiveRecord::Migration[7.1]
  def change
    remove_column :values, :price, :integer
    remove_column :values, :price_cents, :integer
  end
end
