class RemoveRedundantFields < ActiveRecord::Migration
  def change
    drop_table :characters
    drop_table :permission_ranks

    change_table :users do |t|
      t.remove :verified, :reg_ip, :last_ip, :characters, :character_limit, :playchar
    end
  end
end
