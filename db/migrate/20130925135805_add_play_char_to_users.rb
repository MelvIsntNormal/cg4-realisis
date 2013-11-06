class AddPlayCharToUsers < ActiveRecord::Migration
  def change
    add_column :users, :playchar, :integer
  end
end
