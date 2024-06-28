class AddUniqueIndexToAttributes < ActiveRecord::Migration[7.1]
  def change
    add_index :admins, :document_number, unique: true
  end
end
