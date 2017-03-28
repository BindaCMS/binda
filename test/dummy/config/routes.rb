Rails.application.routes.draw do

	root 'pages#index'

  get 'pages', to: 'pages#index', as: :pages
  get 'pages/:id', to: 'pages#show', as: :page

  mount Binda::Engine => "/admin_panel"
end
