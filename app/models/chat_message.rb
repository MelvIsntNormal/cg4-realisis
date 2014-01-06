# Define new Database model for chat messages
class ChatMessage < ActiveRecord::Base
  # Chat messages belong to a single user
  belongs_to :user
  # By default, order records by the date they were created
  default_scope -> { order('created_at DESC') }
  # Validates the user_id field: a value must be present
  validates :user_id, presence: true
  # Validates the meddage field: It cannot exceed 140 characters and it must be present
  validates :message, length: {maximum: 140}, presence: true
end
