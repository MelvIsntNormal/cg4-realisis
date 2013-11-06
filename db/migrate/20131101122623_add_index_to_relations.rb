class AddIndexToRelations < ActiveRecord::Migration
  def change
    add_index :relations, :owner
    add_index :relations, :character
    add_index :relations, [:owner, :character], unique: true
  end
end
