class CreateSingleCharges < ActiveRecord::Migration[7.1]
  def change
    create_table :single_charges do |t|
      t.integer :unit_id
      t.integer :value_cents
      t.date :issue_date
      t.string :description
      t.integer :charge_type, default: 0
      t.integer :condo_id

      t.timestamps
    end
  end
end
