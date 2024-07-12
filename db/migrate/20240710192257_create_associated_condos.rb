class CreateAssociatedCondos < ActiveRecord::Migration[7.1]
  def change
    create_table :associated_condos do |t|
      t.references :admin, null: false, foreign_key: true
      t.integer :condo_id

      t.timestamps
    end
  end
end
