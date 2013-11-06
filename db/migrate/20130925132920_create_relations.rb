class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.integer :owner
      t.integer :character
      t.string :type

      t.timestamps
    end
  end
end
