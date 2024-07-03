class DeleteCondoTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :condos
  end
end
