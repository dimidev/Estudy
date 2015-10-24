class User
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Datatable
  # Include default devise modules. Others available are:
  # :confirmable,  and :omniauthable,
  devise :database_authenticatable, :recoverable, :rememberable,
         :trackable, :validatable ,:lockable, :timeoutable, :registerable

  # User Roles
  ROLES = %w(superadmin admin instructor student)

  # This function determinate the role of user
  # check the user's roles in the Ability class
  def role?(role)
    self.role==role.to_s && ROLES.index(role.to_s)
  end

  ## Database authenticatable
  field :email,              type: String
  field :encrypted_password, type: String
  field :role,               type: String

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  field :locked_at,       type: Time

  has_mongoid_attached_file :user_avatar, style:{medium:'150x150',thumb:'60x60'},
                            url:"/system/:attachment/:style/:basename.:extension",
                            path:":rails_root/public/system/:attachment/:style/:basename.:extension",
                            default_url: :set_default_avatar

  validates_attachment :user_avatar, content_type: {content_type: /\Aimage\/.*\Z/}, size: {less_than: 2.megabytes}
  validates :email, presence: true, format: {with: Devise::email_regexp}
  validates_presence_of :name, :lastname, :gender, :birthdate, unless: lambda{ self.role? :superadmin }
  validates_presence_of :password, on: :create
  validates_confirmation_of :password, unless: lambda { self.password.blank? || self.password.nil? }


  def fullname
    "#{self.name} #{self.lastname}"
  end

  private

  def set_default_avatar
    "user_avatars/#{self.gender}.png"
  end
end
