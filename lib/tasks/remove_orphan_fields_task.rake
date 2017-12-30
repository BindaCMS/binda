namespace :binda do 

	desc "Remove fields which are pointing to non-existing field setting"
	task :remove_orphan_fields => :environment do
		Binda::FieldSetting.get_field_classes.each do |field_class|
			"Binda::#{field_class}".constantize.all.each do |field_instance|
				next if Binda::FieldSetting.where(id: field_instance.field_setting_id).any?
				field_instance.destroy
				puts "Binda::#{field_class} with id ##{field_instance.id} successfully destroyed"
			end
		end
		puts
		puts "All orphans have been removed successfully"
	end

end