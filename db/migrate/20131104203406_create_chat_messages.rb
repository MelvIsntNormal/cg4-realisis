class CreateChatMessages < ActiveRecord::Migration
  def change
    create_table :chat_messages do |t|
      t.string :message
      t.integer :user_id

      t.timestamps
    end
    
    add_index :chat_messages, [:user_id, :created_at]
  end
end
