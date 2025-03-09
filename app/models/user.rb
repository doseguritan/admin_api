class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
  
  include Devise::JWT::RevocationStrategies::JTIMatcher
  
  before_create :set_jti

  def set_jti
    self.jti ||= SecureRandom.uuid
  end

  def jwt_revoked!
    self.update(jti: SecureRandom.uuid)
  end
end
