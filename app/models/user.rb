# Define a new Database model class for users
class User < ActiveRecord::Base
  
  # A user can have many chat messages. When the user id deleted, destroy the messages
  has_many :chat_messages, dependent: :destroy
  
  # A user has many relations. The foreign key is the owner ID field. When the useris deleted, destroy the relationships
  has_many :relations, foreign_key: "owner_id", dependent: :destroy
  # A user has many friends based off the relations relationship. This is shown by the reltype field containing "friend"
  has_many :friends, -> { where "relations.reltype" => "friend" }, through: :relations, source: :character
  # A user has sent many friend requests based off the relations relationship. This is shown by the reltype field containing "freq"
  has_many :requested_friends, -> { where "relations.reltype" => "freq" }, through: :relations, source: :character
  
  # A user has may reverse_relations from the Relations model where the foreign key is character_id. When the user is destroyed, destroy the reverse relations
  has_many :reverse_relations, foreign_key: "character_id", class_name: "Relation", dependent: :destroy
  # A user recieves many friend requests through the reverse_Relations relationship. THis is shown by the reltype field containing "freq"
  has_many :friend_requests, -> { where "relations.reltype" => "freq" }, through: :reverse_relations, source: :owner

  # A user can have many help requests, classed as tickets. Foreign key id sender_id, and when the user is deleted, set ownership of a ticket to nil
  has_many :help_requests, foreign_key: "sender_id", class_name: "Ticket", dependent: :nullify
  has_many :sent_requests, through: :help_requests , source: :sender

  # An administrator an have many tickets assigned to them. The foreign key is assigned id and if the admin is deleted, set assignemnt of the ticket to nil
  has_many :tickets, foreign_key: "assigned_id", dependent: :nullify
  has_many :assigned_tickets, through: :tickets, source: :assigned

  # A user can have only one lock. When the user is deleted, the lock is destroyed
  has_one :lock, dependent: :destroy

  # An administrator can give many locks where the foreign key is locked_by. If the admin is deleted, nullify the primary key
  has_many :given_locks, class_name: "Lock", foreign_key: "locked_by", dependent: :nullify, source: :admin

  # A user can receive many infractions. When a user is deleted, destroy their infractions
  has_many :infractions, dependent: :destroy

  # An admin can give many infractions, where the foreign key is admin_id. If the admin is deleted, nullify the primary key
  has_many :given_infractions, class_name: "Infraction", foreign_key: "admin_id", dependent: :nullify, source: :admin

  # Regular expression for testing emails
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # Before saving a record, do the following
  before_save do
    # Make sure the name is in lowercases and has no spaces
    self.name = name.downcase.gsub(/\s+/, "")
    # Make sure the email string is lowercased
    self.email = email.downcase
  end

  # Before creation of the record, do the following
  before_create do
    # Call this method
    create_remember_token
  end

  # Validates the name field: A name must be present, it cannot exceed 64 letters and it must be unique, but not case sensitive
  validates :name ,    presence: true, length: { maximum: 64 },  uniqueness: { case_sensitive: false }
  # Validates the email field: An email must be present, it cannot exceed 145 characters, it must fit the regular expression specified in the constant and it must be unique, but not case sensitive
  validates :email,    presence: true, length: { maximum: 145 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  # Validates the password field: the password must exceed 8 characters
  validates :password, length: { minimum: 8 }

  # This Rails method automatically handles password security when placed inside any model
  # It implements logicfor the password, confirmation_password, and password digest fields of the model
  # it also hashes passworrds before saving them
  has_secure_password

  # Define new Model method: creates a random sessio token
  def User.new_remember_token
    # Return a random string
    SecureRandom.urlsafe_base64
  end

  # Define new Model method: returns a hash of the given string (Take a String parameter)
  def User.encrypt(token)
    # Hash the string using the SHA1 algorithm
    Digest::SHA1.hexdigest(token.to_s)
  end

  # Define new Model method: checks to see if the user is friends with another user (Takes a User parameter)
  def friends?(other_user)
    # Find a friendship with the user concerning the other_user
    relations.find_by(character_id: other_user.id, reltype: "friend")
  end

  # Define new Model method: checks to see if the user has sent a friend request to another user (Takes a User parameter)
  def pend_friends?(other_user)
    # Find a request sent to the other_user by the current user
    other_user.relations.find_by(character_id: self.id, reltype: "freq")
  end

  # Define new Model method: checks to see if a user has sent a friend request to the current user (Takes a User parameter)
  def req_friends?(other_user)
    # Find a request sent to the current user by the other_user
    relations.find_by(character_id: other_user.id, reltype: "freq")
  end

  # Add a friendship between two users (Takes a User parameter)
  def add_friend!(other_user)
    # Destroy the friend request
    other_user.relations.find_by(character_id: self.id, reltype: "freq").destroy!
    # Create friendship records
    relations.create!(character_id: other_user.id, reltype: "friend")
    other_user.relations.create!(character_id: self.id, reltype: "friend")
  end

  # Define new Model method: removes a friend request after rejection (Takes a User parameter)
  def rej_friend!(other_user)
    # Remove the friend request sent by the other user
    reverse_relations.find_by(owner_id: other_user.id, reltype: "freq").destroy!
  end

  # Define new Model method: creates a new friend request (Takes a User parameter)
  def req_friend!(other_user)
    # Create a friend request to the other user
    relations.create!(character_id: other_user.id, reltype: "freq")
  end

  # Define new Model method: removes a friend (Takes a User parameter)
  def rm_friend!(other_user)
    # Destroy the friend records
    relations.find_by(character_id: other_user.id, reltype: "friend").destroy!
    other_user.relations.find_by(character_id: self.id, reltype: "friend").destroy!
  end

  # Define new Model method: Returns all active infractions
  def active_infractions
    # Get all infractions for the user
    i = infractions
    # Return all active infractions
    i.where('expired = ?', false)
  end

  # Define new Model method: Returns all expired infractions
  def expired_infractions
    # Get all infractions for the user
    i = infractions
    # Return all expired infractions
    i.where('expired = ?', true)
  end

  # Define new Model method: returns an integer value of the total amount of points the user has received
  def infraction_points
    # Return the sum of the poins field for all active infractions
    active_infractions.sum(:points)
  end

  # Define new Model method: returns the infraction level of the user
  def infraction_level
    # Get the first record from the set of Warning levels ordered by descending points where the points filed is less than the points gained by the user
    lvl = WarningLevel.order("points DESC").where(["points < ?", infraction_points]).first
    # If no record was returned
    if lvl.nil?
      # Return 0
      0
    else
      # Return the level as an integer
      lvl.id
    end
  end

  private # Private methods for this class
    # Define new Private Model method: creates a session token
    def create_remember_token
      # Generate the hash for a new token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
