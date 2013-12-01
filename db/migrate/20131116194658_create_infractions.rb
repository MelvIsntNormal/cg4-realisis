class CreateInfractions < ActiveRecord::Migration
  def change
    create_table :infractions do |t|
      t.integer :user_id
      t.integer :admin_id
      t.text :desc
      t.integer :points
      t.timestamp :expires_at

      t.timestamps
    end
  end
end
