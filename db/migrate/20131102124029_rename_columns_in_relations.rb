class RenameColumnsInRelations < ActiveRecord::Migration
  def change
    rename_column :relations, :character, :character_id
    rename_column :relations, :owner, :owner_id
  end
end
