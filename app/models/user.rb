class User < ActiveRecord::Base
  has_secure_password

  before_save :ensure_token

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
