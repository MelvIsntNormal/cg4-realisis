# Define a new Database model for infractions
class Infraction < ActiveRecord::Base
  # Infractions belong to a single user
  belongs_to :user
  # Infractions belong to a single administrator. Administrators are classed as users
  belongs_to :admin, class_name: "User"

  # After a record has been found, execute the following
  after_find do
    # If the record has expired, update its expiry field
    if self.expires_at <= Time.now
      self.expired = true
      self.save
    # Otherise, make sure that the record is not marked as expired
    else
      self.expired = false
      self.save
    end
  end

  # Before saving the record, execute the following
  before_save do
    # Unless the record has expired
    unless self.expired?
      # If the user does not have na infraction level
      if self.user.infraction_level == 0
        # Set the record expiry date to one month from now
        self.expires_at = 1.month.from_now
        # Abort the execution of the do block
        break
      end
      # Get the Warning level of the user
      lvl = WarningLevel.find(self.user.infraction_level)
      # Set the expiry date to the duration of infractions for the respective level
      self.expires_at = lvl.infr_length.months.from_now
    end
  end
end
