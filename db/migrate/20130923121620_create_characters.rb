class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.integer :accountid
      t.string :username
      t.integer :roundles
      t.integer :gems
      t.integer :rank
      t.integer :tier
      t.timestamp :tiertime

      t.timestamps
    end
  end
end
