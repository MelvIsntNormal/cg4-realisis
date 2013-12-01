class RenameColumnsInTickets < ActiveRecord::Migration
  def change
    rename_column :tickets, :assigned, :assigned_id
    rename_column :tickets, :sender, :sender_id
  end
end
