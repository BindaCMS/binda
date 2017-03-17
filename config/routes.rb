Binda::Engine.routes.draw do
  resources :texts
  resources :settings
  post 'pages/sort'
  resources :pages
end
