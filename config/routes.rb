Binda::Engine.routes.draw do
  
	root 'settings#index'

  devise_for :users, class_name: "Binda::User", module: :devise

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
