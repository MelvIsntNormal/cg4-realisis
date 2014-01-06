# Define new Database model for lock records
class Lock < ActiveRecord::Base
  # A lock belongs to a single user
  belongs_to :user
  # Locks belong to a single Administrator. Admins are classed as users
  belongs_to :admin, class_name: 'User'

  # Before saing a record, execute the following
  before_save do
    # Get the user associated with the lock
    thisuser = self.user
    # Get the users points
    points = thisuser.infraction_points
    # Get the first Warning Level record from a set of record in order of points descending, where the points field is less than the number  of points the user has
    lvl =  WarningLevel.order("points DESC").where(["points < ?", points]).first
    # If there is no level
    if lvl.nil?
      # Set the expiry date for the lock to one day from now
      self.expires_at = 1.day.from_now
    else
      # Set the expiry date to the duration found in the Warning level record
      self.expires_at = lvl.lock_length.days.from_now
    end
  end
end
