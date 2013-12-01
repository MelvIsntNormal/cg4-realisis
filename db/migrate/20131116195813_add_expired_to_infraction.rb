class AddExpiredToInfraction < ActiveRecord::Migration
  def change
    add_column :infractions, :expired, :boolean, default: false
  end
end
