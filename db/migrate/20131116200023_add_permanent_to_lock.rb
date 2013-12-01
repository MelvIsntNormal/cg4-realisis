class AddPermanentToLock < ActiveRecord::Migration
  def change
    add_column :locks, :permanent, :boolean, default: false
  end
end
