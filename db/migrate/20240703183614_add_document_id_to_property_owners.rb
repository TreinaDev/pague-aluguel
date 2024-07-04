class AddDocumentIdToPropertyOwners < ActiveRecord::Migration[7.1]
  def change
    add_column :property_owners, :document_id, :string
    add_index :property_owners, :document_id, unique: true
  end
end
