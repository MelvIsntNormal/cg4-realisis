class ChatMessage < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :message, length: {maximum: 140}, presence: true
end
