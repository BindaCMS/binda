require 'json'

module Binda
	module ChoicesHelper 
		# Add helper methods to classes like Binda::Radio, Binda::Select, Binda::Checkbox

		extend ActiveSupport::Concern

		included do
			after_create :set_default_choice
		end

		# Get all choices in an object with key/value pairs
		# 
		# @return [object] object with a pair key/value for each choice
		def get_choices
			JSON.parse( self.field_setting.choices, { symbolize_names: true } )
		end

		# Get the value of the choice
		# 
		# @return [string] the value of the choice
		def get_choice
			# self.get_choices[ self.content ]
			choices = self.get_choices
			choices[ self.content.parameterize.underscore.to_sym ]
		end

		# Set the default key
		# 
		# @return [string] the key of the default choice
		def set_default_choice
			self.content = self.field_setting.default_choice
		end

	end
end