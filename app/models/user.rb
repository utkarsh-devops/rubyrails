class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :token_authenticatable

  handle_asynchronously :send_reset_password_instructions
  handle_asynchronously :send_confirmation_instructions
  handle_asynchronously :send_on_create_confirmation_instructions

  extend UserAuthentication
  extend ApiHelper

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :confirmation_token, :confirmation_sent_at, :confirmed_at, :authentication_token, :role_id

  belongs_to :role
  has_many :events, dependent: :destroy

  # Validations
  validates :first_name, :last_name, presence: true, if: :app_user_creation?
  validates :password, length: { maximum: 20 }, if: :app_user_creation?

  # validates_format_of :email, :with => (/^([^@\s]+)@((weboniselab|eight12|weboapps)\.com|(choc|chocchildrens).org)$/i), :message => "id should be of choc.org or chocchildrens.org or eight12 or weboapps or weboniselab."

  #default_scope where(:confirmation_token => nil)
  scope :app_users,   -> { where("role_id = ? OR id in(?)", Role.get_role_id("App User"), self.admin_already_app_user) }
  scope :admin_users, -> { where(:role_id => Role.get_role_id("Admin User"), :is_deleted => false) }

  # Callbacks
  before_save :ensure_authentication_token!

  def is_admin?
    self.role_id == Role.get_role_id("Super Admin") || self.role_id == Role.get_role_id("Admin User")
  end

  def self.admin_already_app_user
    self.admin_users.where(:is_app_user => true).pluck(:id)
  end

  def app_user_creation?
    self.role_id == Role.get_role_id("App User")
  end

  def password_required?
    app_user_creation?
  end

  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
    password == password_confirmation && !password.blank?
  end
end
