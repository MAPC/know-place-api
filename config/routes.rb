Rails.application.routes.draw do

  jsonapi_resources :profiles, except: [:delete]
  jsonapi_resources :places,   except: [:delete]
  jsonapi_resources :reports,  except: [:delete]
  jsonapi_resources :users,    only: [:show, :create]

  post '/users/sign_in' => 'sessions#create'

  # TODO: Add a root path.

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

end
