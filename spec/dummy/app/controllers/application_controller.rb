class ApplicationController < ActionController::Base
  include ::Binda::MaintenanceHelpers
  protect_from_forgery with: :exception
	include ::Binda::DefaultHelpers
end
