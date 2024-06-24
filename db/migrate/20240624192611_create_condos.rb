class CreateCondos < ActiveRecord::Migration[7.1]
  def change
    create_table :condos do |t|
      t.string :name
      t.string :city

      t.timestamps
    end
  end
end
