class Character < ActiveRecord::Base
  belongs_to :users
  
  before_create do
    self.roundles = 300
    self.gems = 20
    self.rank = 0
    self.tier = 0
    self.tiertime = 0
  end
  
  validates :username, presence: true, length: { maximum: 64 },  uniqueness: { case_sensitive: false }
  
end
