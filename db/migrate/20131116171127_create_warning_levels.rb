class CreateWarningLevels < ActiveRecord::Migration
  def change
    create_table :warning_levels do |t|
      t.string :desc
      t.integer :points
      t.text :comment

      t.timestamps
    end
  end
end
