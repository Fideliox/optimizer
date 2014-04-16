class RboUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
#  SKIP_ACTIVATION = true
#  SKIP_REGISTRATION = true
#  attr_accessor :password
  belongs_to :rbo_role
  before_save :encrypt_password
  after_save :clear_password

  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.encrypted_password = BCrypt::Engine.hash_secret(self.password, salt)
      self.password = nil
    end
  end

  def clear_password
    self.password = nil
  end

  def self.authenticate(username="", login_password="")
    rbo_user = RboUser.where(username: username).first
    if rbo_user && rbo_user.match_password(login_password, rbo_user.salt)
      return rbo_user
    else
      return false
    end
  end

  def match_password(login_password="", salt="")
    encrypted_password == BCrypt::Engine.hash_secret(login_password, salt)
  end

end
