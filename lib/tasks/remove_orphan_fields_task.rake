namespace :binda do 

	desc "Remove fields which are pointing to non-existing field setting"
	task :remove_orphan_fields => :environment do
		Binda::FieldSetting.get_field_classes.each do |field_class|
			# "Binda::#{field_class}".constantize.all.each do |field_instance|
			# 	next if Binda::FieldSetting.where(id: field_instance.field_setting_id).any?
			# 	field_instance.destroy
			# end
			"Binda::#{field_class}"
				.constantize
				.includes(:field_setting)
				.where(binda_field_settings: {id: nil})
				.each do |s| 
					s.destroy
					puts "Binda::#{field_class} with id ##{s.id} successfully destroyed"
				end
			field_types = []
			case field_class
			when 'Selection'
				field_types = %w(selection checkbox radio)
			when 'Text'
				field_types = %w(string text)
			else
				field_types = [ field_class.underscore ]
			end
			"Binda::#{field_class}"
				.constantize
				.includes(:field_setting)
				.where.not(binda_field_settings: {field_type: field_types})
				.each do |s| 
					s.destroy
					puts "Binda::#{field_class} with id ##{s.id} but wrong type successfully destroyed"
				end
		end
		puts
		puts "All orphans have been removed successfully"
	end

end