class RemoveCondoReferenceFromCommonAreas < ActiveRecord::Migration[7.1]
  def change
    remove_reference :common_areas, :condo, null: false, foreign_key: true
  end
end
