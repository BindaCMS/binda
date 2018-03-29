module Binda
	# Binda comes with a bunch of helpers to make life easier.
	module DefaultHelpers
		extend ActiveSupport::Concern

	  class_methods do

			# Get components
			# 
			# This method retrieves **all components** belonging to a specific structure. 
			#   See the following example.
			#   
			# @example Assuming you have two structures 'page' and 'post':
			# 	B.get_components()
			# 	# returns all components from all structures
			# 	
			# 	B.get_components(['page', 'post'])
			# 	# returns pages and posts, i.e. all components belonging to 'page' and 'post' structures
			# 
			#   B.get_components('page')
			#   # returns all pages
			#   
			#		B.get_components('page').find_by(slug: 'my-first-page')
			#		# returns `my-first-page`
			#   
			#   # expand query
			#   B.get_components('page').where(publish_state: 'published').order('position')
			#   
			#   # reduce N+1 query issue by including dependencies
			#   B.get_components('page').includes(:strings, :texts, repeaters: [:images, :selections])
			#   
			# @param slug [string/array] The slug of the structure to which the components belong
			#   
			# @return [ActiveRecord::Relation Object] if slug is nil or is an array
			# 
			def get_components(slug = nil)
				if slug.nil?
					Component.all
				else
					# Generate query
					Component.where(structure_id: Structure.where(slug: slug))
				end
			end

			# Get boards
			# 
			# This method retrieves **boards**.
			#   See the following example.
			#   
			# @example Assuming you have a `default-dashboard`
			# 	B.get_boards()
			# 	# returns all boards of all structures
			# 
			#   B.get_boards('default-dashboard').first
			#   # returns the board
			#   
			#   # reduce N+1 query issue by including dependencies
			#   B.get_boards('default-dashboard').includes(:strings, :texts, repeaters: [:images, :selections]).first
			#   
			# @param slug [string/array] The slug of the structure on which the board is based
			#   
			# @return [ActiveRecord::Relation Object] if slug is nil or is an array  
			# 
			def get_boards(slug = nil)
				if slug.nil?
					Board.all
				else
					Board.where(structure_id: Structure.where(slug: slug))
				end
			end

			# Get categories
			# 
			# This method retrieves **categories**.
			#   See the following example.
			#   
			# @example Assuming you have two structures 'page' and 'post':
			# 	B.get_categories()
			# 	# returns all categories belonging to all structures
			# 
			#   B.get_categories('page')
			#   # returns all categories belonging to the 'page' structure
			#   
			#   B.get_categories(['page', 'post'])
			#   # returns all categories belonging to 'page' structure and the ones belonging to 'post' structure
			#   
			# @param slug [string/array] The slug of the structure to which categories belong
			#   
			# @return [ActiveRecord::Relation Object] 
			# 
			def get_categories(slug = nil)
				if slug.nil?
					Category.all
				else
					Category.where(structure_id: Structure.where(slug: slug))
				end
			end

			# Get field settings
			# 
			# This method retrieves **field settings**.
			#   See the following example.
			# 	
			# @example Assuming you have two field settings 'subtitle' and 'description':
			# 	B.get_field_settings()
			# 	# returns all field settings
			# 	
			# 	B.get_field_settings('subtitle')
			# 	# returns an ActiveRecord::Relation (a sort of Array) containing the 'subtitle' field setting
			# 	
			# @param slug [string/array] The slug of a specific field setting
			# 
			# @return [ActiveRecord::Relation] 
			# 
			def get_field_settings(slug = nil)
				if slug.nil?
					FieldSetting.all
				else
					FieldSetting.where(slug: slug)
				end
			end

			# Get each owner of all relations with the specified slug (or slugs)
			#
			# @param field_slug [string/array] The slug of the field setting to which the relations belong
			# 
			# @return [Array] 
			# 
			def get_relation_owners(field_slug)
				owner_class = Structure.includes(field_groups: :field_settings)
					.where(binda_field_settings: { id: FieldSetting.where(slug: field_slug) })
					.first
				obj = "Binda::#{owner_class.instance_type.classify}".constantize
					.distinct
					.includes(relations: :dependent_components)
					.where(binda_relations: { field_setting_id: FieldSetting.where(slug: field_slug) })
				raise ArgumentError, "There isn't any instance with a relation associated to the current slug (#{field_slug}).", caller if obj.nil?
				return obj
			end


			# Get each dependent of all relations with the specified slug (or slugs)
			#
			# This can be useful to retrieve only the instances which have a owner. For example, you have several 
			#   'event' components, where each one is related to several 'artist' components with a 'partecipants' 
			#   relation field where every event owns some artists. 
			#   If you want to retrieve all artists which have been involved in at least one event you can try with
			#   `B.get_relation_dependents('partecipants')`.
			#   
			# You can also ask for all instance type of dependent or specify 'components' or 'boards' using 
			#   the second parameter.
			#
			# @param field_slug [string] The slug of the field setting to which the relations belong
			# 
			# @return [Array] 
			# 
			def get_relation_dependents(field_slug, instance_type = nil)
				raise ArgumentError, "There isn't any instance named: #{instance_type}. Make sure is either 'component' or 'board'", caller if !instance_type.nil? && ['board','component'].include?(instance_type)
				
				dependents = get_dependents(instance_type, field_slug)
				
				raise ArgumentError, "There isn't any instance with a relation associated to the current slug (#{field_slug}).", caller unless dependents.any?
				return dependents
			end

			private

				# Get dependents based on slug and instance type
				# 
				# @param instance_type [string] The instance type of the record (either board or component)
				# @param field_slug [string] The record slug
				# @return [array] Array of ActiveRecord dependents
				def get_dependents(instance_type, field_slug)
					dependents = []
					if instance_type != 'board'
						dependent_components = Component.distinct
							.includes(:owner_components)
							.where(binda_relations: { field_setting_id: FieldSetting.where(slug: field_slug) })
						dependents = [ *dependents, *dependent_components ]
					elsif instance_type != 'component'
						dependent_boards = Board.distinct
							.includes(:owner_components)
							.where(binda_relations: { field_setting_id: FieldSetting.where(slug: field_slug) })
						dependents = [ *dependents, *dependent_boards ]
					end
					return dependents
				end
	  end
	end
end