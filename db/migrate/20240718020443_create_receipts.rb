class CreateReceipts < ActiveRecord::Migration[7.1]
  def change
    create_table :receipts do |t|
      t.string :name

      t.timestamps
    end
  end
end
