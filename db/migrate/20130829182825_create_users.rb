class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.boolean :verified
      t.string :reg_ip
      t.string :last_ip
      t.integer :character_limit
      t.integer :characters

      t.timestamps
    end
  end
end
