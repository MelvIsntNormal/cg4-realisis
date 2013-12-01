class Infraction < ActiveRecord::Base
  belongs_to :user
  belongs_to :admin, class_name: "User"

  after_find do
    if self.expires_at <= Time.now
      self.expired = true
      self.save
    else
      self.expired = false
      self.save
    end
  end

  before_save do
    unless self.expired?
      if self.user.infraction_level == 0
        self.expires_at = 1.month.from_now
        break
      end
      lvl = WarningLevel.find(self.user.infraction_level)
      self.expires_at = lvl.infr_length.months.from_now
    end
  end
end
