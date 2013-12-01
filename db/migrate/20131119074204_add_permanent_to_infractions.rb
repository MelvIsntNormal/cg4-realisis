class AddPermanentToInfractions < ActiveRecord::Migration
  def change
    add_column :infractions, :permanent, :boolean, default: false
  end
end
