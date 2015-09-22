require 'active_record/session_store'

class ApplicationController < JSONAPI::ResourceController # ActionController::API
  include ActionController::HttpAuthentication::Token

  prepend_before_action :authenticate_user_from_token

  def context
    { current_user: current_user }
  end

  def authenticate_user_from_token
    token, options = token_and_options(request)
    return nil if token.nil? || (email = options[:email]).nil?
    user = User.find_by(email: email, token: token)
    sign_in user
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def current_user
    User.find_by(id: session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
end
