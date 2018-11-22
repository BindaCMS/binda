module Binda
	module FieldableAssociationHelpers
		module FieldableRelationHelpers
		
			# Check if has related components
			# 
			# @param field_slug [string] The slug of the field setting
			# @return [boolean]
			def has_related_components(field_slug)
				obj = self.relations.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
				raise ArgumentError, "There isn't any related field associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
				return obj.dependent_relations.any?
			end

			# Alias for has_related_components
			def has_dependent_components(field_slug)
				has_related_components(field_slug)
			end

			# Get related components
			# 
			# @param field_slug [string] The slug of the field setting
			# @return [array] An array of components
			def get_related_components(field_slug)
				obj = self.relations.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
				raise ArgumentError, "There isn't any related field associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
				return obj.dependent_relations.map{|relation| relation.dependent}
			end

			# Alias for get_related_components
			def get_dependent_components(field_slug)
				get_related_components(field_slug)
			end

			# Get all components which owns a relation where the current instance is a dependent
			# 
			# @param field_slug [string] The slug of the field setting of the relation
			# @return [array] An array of components and/or boards
			def get_owner_components(field_slug)
				# obj = self.owner_relations.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
				obj = Relation.where(field_setting_id: B.get_field_settings(field_slug)).includes(dependent_relations: :dependent).where(binda_relation_links: {dependent_type: self.class.name})
				raise ArgumentError, "There isn't any relation associated to the current slug (#{field_slug}) where the current instance (#{self.class.name} ##{self.id}) is a dependent.", caller if obj.nil?
				return obj
			end

			# Check if has related boards
			# 
			# @param field_slug [string] The slug of the field setting
			# @return [boolean]
			def has_related_boards(field_slug)
				obj = self.relations.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
				raise ArgumentError, "There isn't any related field associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
				return obj.dependent_relations.any?
			end

			# Get related boards
			# 
			# @param field_slug [string] The slug of the field setting
			# @return [array] An array of boards
			def get_related_boards(field_slug)
				obj = self.relations.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
				raise ArgumentError, "There isn't any related field associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
				return obj.dependent_relations.map{|relation| relation.dependent}
			end
			
		end
	end
end