class ApplicationController < ActionController::Base
  include ::Binda::MaintenanceHelpers
  protect_from_forgery with: :exception
end
