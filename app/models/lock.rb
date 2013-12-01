class Lock < ActiveRecord::Base
  belongs_to :user
  belongs_to :admin, class_name: 'User'

  before_save do
    thisuser = self.user
    points = thisuser.infractions.sum(:points)
    lvl =  WarningLevel.order("points DESC").where(["points < ?", points]).first
    if lvl.nil?
      self.expires_at = 1.day.from_now
    else
      self.expires_at = lvl.lock_length.days.from_now
    end
  end
end
