class RenameDocumentIdInPropertyOwners < ActiveRecord::Migration[7.1]
  def change
    rename_column :property_owners, :document_id, :document_number
  end
end
