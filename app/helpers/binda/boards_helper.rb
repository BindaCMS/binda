module Binda
  module BoardsHelper

  	def get_website_name
  		Board.friendly.find('dashboard').get_string('website-name')
  	end

  	def get_website_description
  		Board.friendly.find('dashboard').get_text('website-description')
  	end

  end
end
