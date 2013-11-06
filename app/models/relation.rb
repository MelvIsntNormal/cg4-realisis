class Relation < ActiveRecord::Base
  belongs_to :owner, class_name: "User"
  belongs_to :character, class_name: "User"
  validates :owner_id, presence: true
  validates :character_id, presence: true
end
