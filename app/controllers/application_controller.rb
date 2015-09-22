class ApplicationController < JSONAPI::ResourceController # ActionController::API
  include ActionController::HttpAuthentication::Token

  def context
    { current_user: current_user }
  end

  def current_user
    token, options = token_and_options(request)
    return nil if token.nil? || (email = options[:email]).nil?
    user = User.find_by(email: email, token: token)
  end
end
