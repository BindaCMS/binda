module Binda
	# Binda comes with a bunch of helpers to make life easier.
	module DefaultHelpers
		extend ActiveSupport::Concern

		# Get components
		# 
		# This method retrieves **all components** belonging to a specific structure. 
		#   With this method you can optimize the query in order to avoid the infamous 
		#   [N+1 issue](https://youtu.be/oJ4Ur5XPAF8) by specifing what field types
		#   you are going to request in the view. The list of field types available 
		#   can be found in the [official documentation](https://github.com/lacolonia/binda/wiki/Fields).
		#   Field types must be listed as separated strings, lowercase and plural.
		#   See the following examples.
		#   
		# @example Get all components belonging to `page` structure:
		#   get_components('page')
		#   # return all published pages sorted by position
		#   
		#   get_components('page', { published: false })
		#   # return all published and draft pages sorted by position
		#   
		#   get_components('page', { custom_order: 'created_at DESC' })
		#   # return all published pages sorted chronologically
		#   
		#   get_components('page', { fields: ['strings'] })
		#   get_components('page', { fields: ['strings', 'dates', 'assets'] })
		#   # it optimizes the query in order to avoid the N+1 issue 
		#   # useful if you are going to request any field from these components
		#   # or from any repeaters
		#   
		#   get_components('page', { published: true, custom_order: 'name', fields: ['string', 'repeaters'] })
		#   # it's then possible to create any sort of combination
		#   
		# @param slug [string] The slug of the structure to which the components belong
		# @param args [hash] A hash containing the options used to customize the query.
		# 
		#   The hash parameters are: 
		#   
		#   - `published` (boolean) - Set to true to gather just published components, 
		#   false to get them all
		#   - `custom_order` (string) - Set the order parameter. Default is `position`, 
		#   but you can use any of the following `created_at`, `updated_at`, `id`, `name`, `slug`.
		#   Append `DESC` if you want to reverse the order, e.g. `position DESC`
		#   - `fields` (array) - Include related field classes to the query. The list of field types available 
		#   can be found in the [official documentation](https://github.com/lacolonia/binda/wiki/Fields).
		#   Field types must be listed as separated strings, lowercase and plural.
		#   
		# @return [ActiveRecord Object]  
		def get_components( slug, args = { published: true, custom_order: 'position', fields: [] })
			
			validate_provided_arguments( args )
			args = set_default_args( args )
			validate_provided_fields( args )
			validate_provided_custom_order( args )

			# Generate query
			case 
				when args[:published] && args[:fields].any?
					Component.where( structure_id: Structure.where( slug: slug ) ).published.includes( args[:fields] )
				when args[:published]
					Component.where( structure_id: Structure.where( slug: slug ) ).published
				when args[:fields].any?
					Component.where( structure_id: Structure.where( slug: slug ) ).order( args[:custom_order] ).includes( args[:fields] )
				else
					Component.where( structure_id: Structure.where( slug: slug ) ).order( args[:custom_order] )
			end	 
		end

		# This method retrieves a **single component**.
		#   With this method you can optimize the query in order to avoid the infamous 
		#   [N+1 issue](https://youtu.be/oJ4Ur5XPAF8) by specifing what field types
		#   you are going to request in the view. The list of field types available 
		#   can be found in the [official documentation](https://github.com/lacolonia/binda/wiki/Fields).
		#   Field types must be listed as separated strings, lowercase and plural.
		#   See the following examples.
		#   
		# @example Get a component with slug `my-first-post`
		#   get_component('my-first-post')
		#   # return the component
		#   
		#   get_component('my-first-post', { fields: ['strings', 'texts', 'assets', 'selections'] })
		#   # return the component and optimize the query for any of the listed fields related to it
		#   
		#   
		# @param slug [string] The slug of the component
		# @param args [hash] A hash containing the options used to customize the query.
		# 
		#   The hash parameters are: 
		#   
		#   - `fields` (array) - Include related field classes to the query. The list of field types available 
		#   can be found in the [official documentation](https://github.com/lacolonia/binda/wiki/Fields).
		#   Field types must be listed as separated strings, lowercase and plural.
		#   
		# @return [ActiveRecord Object]  
		def get_component( slug, args = { fields: [] })

			validate_provided_arguments( args )

			# Sets defaults
			args[:fields] = [] if args[:fields].nil?

			validate_provided_fields( args )

			if args[:fields].any?
				Component.where(slug: slug).includes( args[:fields] ).first
			else
				Component.where(slug: slug).first
			end
		end

		# This method retrieves a **board**.
		#   With this method you can optimize the query in order to avoid the infamous 
		#   [N+1 issue](https://youtu.be/oJ4Ur5XPAF8) by specifing what field types
		#   you are going to request in the view. The list of field types available 
		#   can be found in the [official documentation](https://github.com/lacolonia/binda/wiki/Fields).
		#   Field types must be listed as separated strings, lowercase and plural.
		#   See the following examples.
		#   
		# @example Get a board with slug `my-dashboard`
		#   get_board('my-dashboard')
		#   # return the board
		#   
		#   get_board('my-dashboard', { fields: ['strings', 'texts', 'assets', 'selections'] })
		#   # return the board and optimize the query for any of the listed fields related to it
		#   
		#   
		# @param slug [string] The slug of the board
		# @param args [hash] A hash containing the options used to customize the query.
		# 
		#   The hash parameters are: 
		#   
		#   - `fields` (array) - Include related field classes to the query. The list of field types available 
		#   can be found in the [official documentation](https://github.com/lacolonia/binda/wiki/Fields).
		#   Field types must be listed as separated strings, lowercase and plural.
		#   
		# @return [ActiveRecord Object]  
		def get_board( slug, args = { fields: [] })
			
			validate_provided_arguments( args )

			# Sets defaults
			args[:fields] = [] if args[:fields].nil?
			
			validate_provided_fields( args )

			if args[:fields].any?
				Board.where(slug: slug).includes( args[:fields] ).first
			else
				Board.where(slug: slug).first
			end
		end

		private 

			# Check if provided `fields` are ok, otherwise raise an error
			def validate_provided_fields( args )
				raise ArgumentError, "Error in get_components(): fields should be an Array, not a #{args[:fields].class}.", caller unless args[:fields].instance_of? Array
				args[:fields].each do |f|
					raise ArgumentError, "Error in get_components(): #{f} is not a valid field type.", caller unless FieldSetting.get_field_classes.map{ |fc| fc.underscore.pluralize }.include? f.to_s
				end
			end

			# Check if provided `custom_order` is ok, otherwise raise an error
			def validate_provided_custom_order( args )
				raise ArgumentError, "Error in get_components(): custom_order should be a String, not a #{args[:custom_order].class}.", caller unless args[:custom_order].instance_of? ::String
			end

			# Check if provided arguments are ok, otherwise raise an error
			def validate_provided_arguments( args )
				args.each do |key, _|
					raise ArgumentError, "Error in get_components(): #{key} is not a valid key.", caller unless ['published', 'custom_order', 'fields'].include? key.to_s
				end
			end

			def set_default_args( args )
				# Sets defaults
				args[:published]    = 'true'     if args[:published].nil?
				args[:custom_order] = 'position' if args[:custom_order].nil?
				args[:fields]       = []         if args[:fields].nil?
				return args
			end
	end
end