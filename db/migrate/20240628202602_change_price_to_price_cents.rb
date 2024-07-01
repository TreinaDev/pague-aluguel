class ChangePriceToPriceCents < ActiveRecord::Migration[7.1]
  def change
    add_monetize :values, :price
  end
end
