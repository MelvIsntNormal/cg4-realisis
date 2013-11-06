class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :title
      t.text :desc
      t.integer :sender
      t.integer :assigned
      t.text :addinfo

      t.timestamps
    end
  end
end
