Rails.application.routes.draw do

	mount Binda::Engine => "/admin_panel"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
