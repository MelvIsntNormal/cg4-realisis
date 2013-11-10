class Ticket < ActiveRecord::Base
  belongs_to :sender, class_name: "User", foreign_key: "id", inverse_of: :sent_tickets
  belongs_to :admin, class_name: "User", foreign_key: "id", inverse_of: :assigned_tickets
  
  
  before_save do
    self.assigned = nil
  end
  
end
