class CreateBills < ActiveRecord::Migration[7.1]
  def change
    create_table :bills do |t|
      t.integer :unit_id
      t.date :issue_date
      t.date :due_date
      t.integer :total_value_cents

      t.timestamps
    end
  end
end
