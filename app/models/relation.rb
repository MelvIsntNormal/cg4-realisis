# Define a Database model for relations
class Relation < ActiveRecord::Base
  # Relations belong to an owner, which are classed as users
  belongs_to :owner, class_name: "User"
  # Relations belong to a character, which are classed as users
  belongs_to :character, class_name: "User"

  # Validates the owner_id field: a value must be present
  validates :owner_id, presence: true
  # Validates the character_id field: a value must be present
  validates :character_id, presence: true
end
