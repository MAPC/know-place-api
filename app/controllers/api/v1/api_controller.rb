module API
  module V1
    class APIController < JSONAPI::ResourceController

      # prepend_before_action :authenticate_user_from_token!

      # def context
      #   { current_user: current_api_user }
      # end

      private

      # def authenticate_user_from_token!
      #   authenticate_with_http_token do |token, options|
      #     email = options[:email].presence
      #     user = email && User.find_by(email: email)

      #     if user && Devise.secure_compare(user.authentication_token, token)
      #       sign_in user, store: false
      #     end
      #   end
      # end

    end
  end
end
