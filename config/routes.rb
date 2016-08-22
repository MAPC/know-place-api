require 'api_version'
require 'subdomain_constraint'

Rails.application.routes.draw do

  namespace :admin do
    resources :profiles
    resources :places
    resources :reports
    resources :users
    resources :data_collections
    resources :aggregators
    resources :data_points
    resources :data_sources
    resources :fields
    resources :topics

    root to: "profiles#index"
  end

  namespace :api, constraints: SubdomainConstraint.new(/^api/), path: '' do
    api_version(APIVersion.new(version: 1, default: true).params) do
      jsonapi_resources :profiles, except: [:delete]
      jsonapi_resources :places,   except: [:delete]
      jsonapi_resources :reports,  except: [:delete]
      jsonapi_resources :users,    only: [:show, :create]

      devise_for :users, controllers: { sessions: 'api/v1/sessions' }
      post '/users/sign_in' => 'sessions#create'
    end
  end

  # TODO: Add a root path.
  # root 'welcome#index'

end
