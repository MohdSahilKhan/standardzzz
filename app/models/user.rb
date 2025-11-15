class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  before_save :ensure_login_token
  has_and_belongs_to_many :managers,
  class_name: 'User',
  join_table: 'managers_users',
  foreign_key: 'user_id',
  association_foreign_key: 'manager_id' 

  has_many :documents , dependent: :destroy
  before_destroy :delete_documents

  validates :email, presence: true, uniqueness: { case_sensitive: false }, on: :create
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :mobile_number, uniqueness: true
  def ensure_login_token
    self.login_token ||= Devise.friendly_token
  end

  def regenerate_login_token
    self.update!(login_token: Devise.friendly_token)
  end

  private

  def delete_documents
    self.documents.destroy_all
  end
  # validates :employee_type, inclusion: { in: ['full time', 'contract'] }
  # validates :job_type, inclusion: { in: ['remote', 'wfo'] }

  after_create :assign_default_role

  def assign_default_role
    self.add_role(:employee) unless self.has_any_role?
  end
  has_many :bank_details, dependent: :destroy
  has_one_attached :profile_picture
end
