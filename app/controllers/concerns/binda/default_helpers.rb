module Binda
	# Binda comes with a bunch of helpers to make life easier.
	module DefaultHelpers
		extend ActiveSupport::Concern

	  # Get components
	  # 
		# This method retrieves all components belonging to a specific structure. 
		#   With this method you can optimize the query in order to avoid the infamous 
		#   [N+1 issue](https://youtu.be/oJ4Ur5XPAF8) by specifing what field types
		#   are going to be requested in the view. The list of field types available 
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
		#   
		# @return [ActiveRecord Object]  
	  def get_components( slug, args = { published: true, custom_order: 'position', fields: [] } )
			
	  	# Sets defaults
			args[:published]    = 'true'     if args[:published].nil?
			args[:custom_order] = 'position' if args[:custom_order].nil?
			args[:fields]       = []         if args[:fields].nil?

			# Check if provided arguments are ok, otherwise help finding the error
			raise ArgumentError, "Argument error in get_components(): custom_order should be a String, not a #{args[:custom_order].class.to_s}.", caller unless args[:custom_order].instance_of? ::String
			raise ArgumentError, "Argument error in get_components(): #{args[:custom_order]} is not valid.", caller unless args[:custom_order].instance_of? ::String
			raise ArgumentError, "Argument error in get_components(): fields should be an Array, not a #{args[:fields].class.to_s}.", caller unless args[:fields].instance_of? Array
			args[:fields].each do |f|
				raise ArgumentError, "Argument error in get_components(): #{f.to_s} is not a valid field type.", caller unless FieldSetting.get_field_classes.map{ |fc| fc.underscore.pluralize }.include? f.to_s
			end

			# Generate query
			if args[:published]
				if args[:fields].any?
					components = Structure.where( slug: slug ).first.components.published.includes( args[:fields] )
				else
					components = Structure.where( slug: slug ).first.components.published
				end
			else
				if args[:fields].any?
					components = Structure.where( slug: slug ).first.components.order( args[:custom_order] ).includes( args[:fields] )
				else
					components = Structure.where( slug: slug ).first.components.order( args[:custom_order] )
				end
			end
			return components
		end
	end
end