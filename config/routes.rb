Binda::Engine.routes.draw do

  # ROOT
  # ----
  # https://github.com/plataformatec/devise/wiki/How-To:-Require-authentication-for-all-components
  authenticated :user, class_name: "Binda::User", module: :devise do
    root to: 'settings#index', as: :authenticated_root
  end
  root to: redirect( "users/sign_in" )

  root 'settings#dashboard'

  # DEVISE
  # ------
  devise_for :users, class_name: "Binda::User", module: :devise, controllers: { 
        sessions:       'binda/users/sessions',
        confirmations:  'binda/users/confirmations',
        passwords:      'binda/users/passwords',
        registrations:  'binda/users/registrations',
        unlocks:        'binda/users/unlocks'
      }

  namespace :manage do
    resources :users
  end

  # ADMINISTRATION PANEL
  # --------------------
  get  'dashboard', to: 'settings#dashboard',         as: :dashboard
  post 'dashboard', to: 'settings#update_dashboard'
  resources :settings

  post 'structures/sort'
  resources :structures do

    resources :categories

    post 'components/sort'
    resources :components do
      post 'sort_repeaters'
      post 'new_repeater'
    end

    post 'field_groups/sort'
    post 'field_groups/add_child'
    resources :field_groups do

      post 'field_settings/add_child'
      post 'field_settings/sort'
      resources :field_settings

    end
  end
  
  resources :texts
  resources :bindings
  resources :galleries
  resources :assets
  resources :repeaters
  resources :dates
  
end
