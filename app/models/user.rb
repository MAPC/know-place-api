class User < ActiveRecord::Base
  has_secure_password

  has_many :places
  has_many :profiles

  before_save :ensure_token

  validates :email, presence: true, uniqueness: true

  private

    def ensure_token
      if token.blank?
        self.token = generate_token
      end
    end

    def generate_token
      loop do
        token = SecureRandom.base64
        break token unless User.where(token: token).first
      end
    end
end
