Binda::Engine.routes.draw do

  # ROOT
  # ----
  # https://github.com/plataformatec/devise/wiki/How-To:-Require-authentication-for-all-components
  # https://stackoverflow.com/a/24135199/1498118
  authenticated :user, class_name: "Binda::User", module: 'binda/users' do
    root to: "boards#dashboard"
  end
  unauthenticated :user do
    devise_scope :user do
      get "/", to: "users/sessions#new"
    end
  end

  # DEVISE
  # ------
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

  namespace :manage do
    resources :users
  end

  # ADMINISTRATION PANEL
  # --------------------
  get  'dashboard', to: 'boards#dashboard', as: :dashboard

  post 'structures/sort'
  get 'structures/sort_index'
  resources :structures do
    post 'field_groups/sort'
    post 'field_groups/add_child'
    resources :field_groups do
      post 'field_settings/add_child'
      post 'field_settings/sort'
      resources :field_settings
    end
    resources :boards do
      post 'sort_repeaters'
      post 'new_repeater'
      member do
        patch 'upload'
      end
    end
    post 'components/sort'
    get 'components/sort_index'
    resources :components do
      post 'sort_repeaters'
      post 'new_repeater'
      member do
        patch 'upload'
      end
    end
    resources :categories
  end

  resources :choices, only: [:destroy]
  
  resources :videos do
    member do
      delete 'remove_video'
    end
  end

  resources :images do
    member do
      delete 'remove_image'
    end
  end
  resources :repeaters

end
