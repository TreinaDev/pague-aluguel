class CreateBillDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :bill_details do |t|
      t.string :description
      t.integer :value_cents
      t.integer :fee_type
      t.references :bill, null: false, foreign_key: true

      t.timestamps
    end
  end
end
