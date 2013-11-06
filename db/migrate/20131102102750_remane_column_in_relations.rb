class RemaneColumnInRelations < ActiveRecord::Migration
  def change
    rename_column :relations, :type, :reltype
  end
end
