Rails.application.routes.draw do

	root 'pages#index'

  get 'pages/index'
  get 'pages/show'

  mount Binda::Engine => "/admin_panel"
end
