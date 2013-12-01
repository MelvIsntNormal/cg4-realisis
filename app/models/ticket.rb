class Ticket < ActiveRecord::Base
  belongs_to :assigned, class_name: "User"
  belongs_to :sender, class_name: "User"

  def assign_to! (id)
    update_attribute :assigned_id, id
  end

  def assigned?
    assigned_id != nill
  end
  
end
