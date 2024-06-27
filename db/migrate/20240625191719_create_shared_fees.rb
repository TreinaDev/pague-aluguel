class CreateSharedFees < ActiveRecord::Migration[7.1]
  def change
    create_table :shared_fees do |t|
      t.string :description
      t.date :issue_date
      t.integer :total_value
      t.references :condo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
