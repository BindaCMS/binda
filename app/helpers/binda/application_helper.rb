module Binda
  module ApplicationHelper

		def main_app
		  Rails.application.class.routes.url_helpers
		end

  end
end
