class CreateLocks < ActiveRecord::Migration
  def change
    create_table :locks do |t|
      t.integer :user_id
      t.integer :locked_by
      t.string :desc
      t.timestamp :expires_at

      t.timestamps
    end
  end
end
