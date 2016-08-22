require 'rails-api'

module API
  module V1
    class SessionsController < ActionController::API

      # skip_before_action :authenticate!, only: [:create]

      # def create
      #   user = User.find_by_email(session_params[:email])
      #   if user && user.authenticate(session_params[:password])
      #     data = {
      #       token: user.authentication_token,
      #       email: user.email,
      #       user_id: user.id
      #     }
      #     render json: data, status: :created and return
      #   else
      #     render status: :unauthorized, json: {}
      #   end
      # end

      # private

      # def session_params
      #   params.permit(:email, :password)
      # end

    end
  end
end
