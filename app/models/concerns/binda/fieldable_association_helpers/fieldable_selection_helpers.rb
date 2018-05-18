module Binda
	module FieldableAssociationHelpers
		module FieldableSelectionHelpers		
			# Get the radio choice
			# 
			# If by mistake the Radio instance has many choices associated, 
			#   only the first one will be retrieved.
			# 
			# @param field_slug [string] The slug of the field setting
			# @return [hash] A hash of containing the label and value of the selected choice. `{ label: 'the label', value: 'the value'}`
			def get_radio_choice(field_slug)
				field_setting = FieldSetting.find_by(slug:field_slug)
				obj = self.radios.find{ |t| t.field_setting_id == field_setting.id }
				raise ArgumentError, "There isn't any radio associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
				raise "There isn't any choice available for the current radio (#{field_slug}) on instance (#{self.class.name} ##{self.id})." unless obj.choices.any?
				return { label: obj.choices.first.label, value: obj.choices.first.value }
			end

			# Get the select choice
			# 
			# @param field_slug [string] The slug of the field setting
			# @return [hash] A hash of containing the label and value of the selected choice. `{ label: 'the label', value: 'the value'}`
			def get_selection_choice(field_slug)
				field_setting = FieldSetting.find_by(slug:field_slug)
				obj = self.selections.find{ |t| t.field_setting_id == field_setting.id }
				raise ArgumentError, "There isn't any selection associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
				raise "There isn't any choice available for the current selection (#{field_slug}) on instance (#{self.class.name} ##{self.id})." unless field_setting.choices.any?
				return { label: obj.choices.first.label, value: obj.choices.first.value }
			end

			# Get the select choices
			# 
			# @param field_slug [string] The slug of the field setting
			# @return [array] An array of hashes of containing label and value of the selected choices. `{ label: 'the label', value: 'the value'}`
			def get_selection_choices(field_slug)
				field_setting = FieldSetting.find_by(slug:field_slug)
				obj = self.selections.find{ |t| t.field_setting_id == field_setting.id }
				raise ArgumentError, "There isn't any selection associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
				raise "There isn't any choice available for the current selection (#{field_slug}) on instance (#{self.class.name} ##{self.id})." unless field_setting.choices.any?
				return obj.choices.map{|choice| { label: choice.label, value: choice.value }}
			end

			# Get the checkbox choice
			# 
			# @param field_slug [string] The slug of the field setting
			# @return [array] An array of labels and values of the selected choices. `[{ label: '1st label', value: '1st-value'}, { label: '2nd label', value: '2nd-value'}]`
			def get_checkbox_choices(field_slug)
				field_setting = FieldSetting.find_by(slug:field_slug)
				obj = self.checkboxes.find{ |t| t.field_setting_id == field_setting.id }
				raise ArgumentError, "There isn't any checkbox associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
				raise "There isn't any choice available for the current checkbox (#{field_slug}) on instance (#{self.class.name} ##{self.id})." unless field_setting.choices.any?
				obj_array = []
				obj.choices.order('label').each do |o|
					obj_array << { label: o.label, value: o.value }
				end
				return obj_array
			end
		end
	end
end