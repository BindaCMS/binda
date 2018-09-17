namespace :binda do
	desc "Create missing field instances for each component and board"
	task :create_missing_field_instances => :environment do
		%w( Component Board ).each do |instance_class|
			"Binda::#{instance_class}".constantize.all.each do |instance|
				puts "Ready to check #{instance_class.downcase} ##{instance.id}"
				instance.create_field_instances
				puts "Check completed"
			end
		end
	end
end