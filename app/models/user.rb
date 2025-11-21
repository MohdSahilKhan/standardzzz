class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  before_save :ensure_login_token
  def email_required?
    false
  end

  def email_changed?
    false
  end

  def will_save_change_to_email?
    false
  end

  def password_required?
    false
  end
  # validates :email, presence: true, uniqueness: { case_sensitive: false }, on: :create
  # validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :mobile_number, uniqueness: true
  has_many :orders, dependent: :destroy
  def ensure_login_token
    self.login_token ||= Devise.friendly_token
  end

  def regenerate_login_token
    self.update!(login_token: Devise.friendly_token)
  end
  
  def self.ransackable_attributes(auth_object = nil)
    [
      "id",
      "full_name",
      "email",
      "mobile_number",
      "gender",
      "city",
      "state",
      "is_active",
      "created_at",
      "updated_at"
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  private
  after_create :assign_default_role

  def assign_default_role
    self.add_role(:user) unless self.has_any_role?
  end
end
