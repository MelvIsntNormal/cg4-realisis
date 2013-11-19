class Ticket < ActiveRecord::Base
  belongs_to :assigned, class_name: "User"
  belongs_to :sender, class_name: "User"
  
  
  before_save do
    self.assigned = nil
  end
  
end
