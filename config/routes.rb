Binda::Engine.routes.draw do

  # ROOT
  # ----
  # https://github.com/plataformatec/devise/wiki/How-To:-Require-authentication-for-all-pages
  authenticated :user, class_name: "Binda::User", module: :devise do
    root to: 'settings#index', as: :authenticated_root
  end
  root to: redirect( "users/sign_in")


  # DEVISE
  # ------
  devise_for :users, 
    class_name: "Binda::User", 
    module: :devise, 
      controllers: { 
        sessions:       'binda/users/sessions',
        confirmations:  'binda/users/confirmations',
        passwords:      'binda/users/passwords',
        registrations:  'binda/users/registrations',
        unlocks:        'binda/users/unlocks'
      }


  # ADMINISTRATION PANEL
  # --------------------
  resources :settings

  post 'pages/sort'
  post 'pages/fields_update'
  resources :pages
  resources :structures
  post 'field_groups/sort'
  resources :field_groups
  post 'field_settings/sort'
  resources :field_settings, except: [ :show, :index ]
  resources :texts, except: [ :show, :index ]
  resources :categories

end
