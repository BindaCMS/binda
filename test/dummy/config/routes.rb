Rails.application.routes.draw do

  root 'pages#index'
	get 'pages', to: 'pages#index', as: :pages
	get 'pages/:id', to: 'pages#show', as: :page
	
	mount Binda::Engine => "/admin_panel"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
