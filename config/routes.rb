Binda::Engine.routes.draw do

  # ROOT
  # ----
  # https://github.com/plataformatec/devise/wiki/How-To:-Require-authentication-for-all-components
  # authenticated :user, class_name: "Binda::User", module: :devise do
  #   root to: 'settings#dashboard', as: :authenticated_root
  # end
  # root to: 'users/sessions#new'
  root to: 'settings#dashboard'

  # DEVISE
  # ------
  # scope "admindd_ddpanel" do
    # https://github.com/plataformatec/devise/blob/88724e10adaf9ffd1d8dbfbaadda2b9d40de756a/lib/devise/rails/routes.rb#L143
    devise_for :users, class_name: "Binda::User", module: 'binda/users',
    path_names: { 
      sign_in: 'login', 
      sign_out: 'logout', 
      password: 'secret', 
      confirmation: 'verification', 
      unlock: 'unblock', 
      registration: 'register',
      sign_up: 'signup'
    }
  # end

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
