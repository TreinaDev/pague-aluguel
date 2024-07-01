class AddCondoIdToBaseFees < ActiveRecord::Migration[7.1]
  def change
    add_reference :base_fees, :condo, foreign_key: true
  end
end
