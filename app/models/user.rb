class User < ActiveRecord::Base
  
  has_many :characters, foreign_key: "accountid", dependent: :destroy
  has_many :chat_messages, dependent: :destroy
  
  has_many :relations, foreign_key: "owner_id", dependent: :destroy
  has_many :friends, -> { where "relations.reltype" => "friend" }, through: :relations, source: :character
  has_many :requested_friends, -> { where "relations.reltype" => "freq" }, through: :relations, source: :character
  
  has_many :reverse_relations, foreign_key: "character_id", class_name: "Relation", dependent: :destroy
  has_many :friend_requests, -> { where "relations.reltype" => "freq" }, through: :reverse_relations, source: :owner

  has_many :help_requests, foreign_key: "sender_id", class_name: "Ticket", dependent: :nullify
  has_many :sent_requests, through: :help_requests , source: :sender

  has_many :tickets, foreign_key: "assigned_id", dependent: :nullify
  has_many :assigned_tickets, through: :tickets, source: :assigned

  has_one :lock, dependent: :destroy
  has_many :given_locks, class_name: "Lock", foreign_key: "locked_by", dependent: :nullify, source: :admin

  has_many :infractions, dependent: :destroy
  has_many :given_infractions, class_name: "Infraction", foreign_key: "admin_id", dependent: :nullify, source: :admin
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  before_save do
    self.name = name.downcase.gsub(/\s+/, "")
    self.email = email.downcase
  end
  
  before_create do
    create_remember_token
  end
  
  validates :name ,    presence: true, length: { maximum: 64 },  uniqueness: { case_sensitive: false }
  validates :email,    presence: true, length: { maximum: 145 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }
  
  has_secure_password
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  def friends?(other_user)
    relations.find_by(character_id: other_user.id, reltype: "friend")
  end
  
  def pend_friends?(other_user)
    other_user.relations.find_by(character_id: self.id, reltype: "freq")
  end
  
  def req_friends?(other_user)
    relations.find_by(character_id: other_user.id, reltype: "freq")
  end
  
  def add_friend!(other_user)
    other_user.relations.find_by(character_id: self.id, reltype: "freq").destroy!
    relations.create!(character_id: other_user.id, reltype: "friend")
    other_user.relations.create!(character_id: self.id, reltype: "friend")
  end
  
  def rej_friend!(other_user)
    reverse_relations.find_by(owner_id: other_user.id, reltype: "freq").destroy!
  end
  
  def req_friend!(other_user)
    relations.create!(character_id: other_user.id, reltype: "freq")
  end
  
  def rm_req!(other_user)
    reverse_relations.find_by(owner_id: other_user.id, reltype: "freq").destroy!
  end
  
  def rm_friend!(other_user)
    relations.find_by(character_id: other_user.id, reltype: "friend").destroy!
    other_user.relations.find_by(character_id: self.id, reltype: "friend").destroy!
  end

  def infraction_points
    infractions.sum(:points)
  end

  def infraction_level
    lvl = WarningLevel.order("points DESC").where(["points < ?", infraction_points]).first
    if lvl.nil?
      0
    else
      lvl.id
    end
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
