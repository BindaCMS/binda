module Binda
	# Binda comes with a bunch of helpers to make life easier.
	module DefaultHelpers
		extend ActiveSupport::Concern

		included do 
		end

	  class_methods do

			# Get components method
			# 
			# This method retrieves **all components** belonging to a specific structure. 
			#   See the following example.
			#   
			# @example Get all components belonging to `page` structure:
			#   Binda.get_components('page')
			#   # return all pages
			#   
			#		Binda.get_components('page').find_by(slug: 'my-first-page')
			#		# return `my-first-page`
			#   
			#   # expand query
			#   Binda.get_components('page').where(publish_state: 'published').order('position')
			#   
			#   # reduce N+1 query issue by including dependencies
			#   Binda.get_components('page').includes(:strings, :texts, repeaters: [:images, :selections])
			#   
			# @param slug [string] The slug of the structure to which the components belong
			#   
			# @return [ActiveRecord Object]
			def get_components slug 

				# Generate query
				Component.where( structure_id: Structure.where( slug: slug ) )
			end

			# Get boards method
			# 
			# This method retrieves **boards**.
			#   See the following example.
			#   
			# @example Get a board with slug `default-dashboard`
			#   Binda.get_boards('default-dashboard').first
			#   # return the board
			#   
			#   # reduce N+1 query issue by including dependencies
			#   Binda.get_boards('default-dashboard').includes(:strings, :texts, repeaters: [:images, :selections]).first
			#   
			# @param slug [string] The slug of the structure on which the board is based
			#   
			# @return [ActiveRecord Object]  
			def get_boards slug 
				
				Board.where( structure_id: Structure.where( slug: slug ) )
			end

	  end
	end
end