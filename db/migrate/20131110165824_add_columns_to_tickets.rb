class AddColumnsToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :action_taken, :text
  end
end
