class CreateUnits < ActiveRecord::Migration[7.1]
  def change
    create_table :units do |t|
      t.integer :area
      t.integer :floor
      t.integer :number

      t.timestamps
    end
  end
end
