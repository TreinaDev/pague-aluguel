class CreateReceipts < ActiveRecord::Migration[7.1]
  def change
    create_table :receipts do |t|
      t.string :bill_id

      t.timestamps
    end
  end
end
