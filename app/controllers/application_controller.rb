class ApplicationController < JSONAPI::ResourceController # ActionController::API
  def context
    # { current_user: current_user }
  end
end
