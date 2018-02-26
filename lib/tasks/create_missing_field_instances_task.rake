namespace :binda do
	desc "Create missing field instances for each component and board"
	task :create_missing_field_instances => :environment do
		Binda::Component.all.each do |component|
			puts "checking component ##{component.id}"
			component.create_field_instances
			puts "component ##{component.id} checked"
		end
	end
end