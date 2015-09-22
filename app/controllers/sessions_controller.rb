class SessionsController < ActionController::API
  skip_before_action :authenticate!, only: [:create]
  def create
    # TODO Dry this out by using the Warden PasswordStrategy
    user = User.find_by(email: session_params[:email])
    if user && user.authenticate(session_params[:password])
      render status: :ok, json: {
        user_id: user.id, email: user.email, token: user.token
      }
    else
      render status: :unauthorized, json: ""
    end
  end

  private

    def session_params
      params.permit(:email, :password)
    end
end