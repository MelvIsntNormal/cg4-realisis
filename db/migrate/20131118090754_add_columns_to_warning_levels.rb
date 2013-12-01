class AddColumnsToWarningLevels < ActiveRecord::Migration
  def change
    add_column :warning_levels, :lock_length, :integer
    add_column :warning_levels, :infr_length, :integer
  end
end
