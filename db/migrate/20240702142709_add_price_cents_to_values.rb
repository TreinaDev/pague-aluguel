class AddPriceCentsToValues < ActiveRecord::Migration[7.1]
  def change
    add_column :values, :price_cents, :integer
  end
end
