namespace :binda do
	desc "Create missing field instances for each component and board"
	task :create_missing_field_instances => :environment do
		%w( Component Board ).each do |instance_class|
			"Binda::#{instance_class}".constantize.all.each do |instance|
				puts "Checking Binda::#{instance_class} with id = #{instance.id} ..."
				instance.create_field_instances
				puts "Check completed"
			end
		end
	end
end