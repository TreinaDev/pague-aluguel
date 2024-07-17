class CreateRentFees < ActiveRecord::Migration[7.1]
  def change
    create_table :rent_fees do |t|
      t.integer :tenant_id
      t.integer :owner_id
      t.integer :condo_id
      t.integer :unit_id
      t.integer :value_cents
      t.date :issue_date
      t.integer :fine_cents
      t.decimal :fine_interest

      t.timestamps
    end
  end
end
