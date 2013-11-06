require 'active_record/fixtures'

class CreatePermissionRanks < ActiveRecord::Migration
  def change
    create_table :permission_ranks do |t|
      t.string :label
      t.integer :badge

      t.timestamps
    end

  end
end
