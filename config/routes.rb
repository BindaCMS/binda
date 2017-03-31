Binda::Engine.routes.draw do

  # ROOT
  # ----
  # https://github.com/plataformatec/devise/wiki/How-To:-Require-authentication-for-all-pages
  # authenticated :user, class_name: "Binda::User", module: :devise do
  #   root to: 'settings#index', as: :authenticated_root
  # end
  # root to: redirect( "users/sign_in")

  root 'settings#index'

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

  resources :structures do

    post 'pages/sort'
    resources :pages
    
    post 'field_groups/sort'
    post 'field_groups/add_child'
    resources :field_groups do

      post 'field_settings/add_child'
      post 'field_settings/sort'
      resources :field_settings

    end
  end
  
  resources :texts
  resources :categories
  resources :bindings
  resources :galleries
  resources :assets
  resources :repeaters
  
end
