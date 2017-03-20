Binda::Engine.routes.draw do
  resources :field_groups
  resources :field_settings
  resources :structures
  resources :texts
  resources :settings
  post 'pages/sort'
  resources :pages
end
