namespace :binda do 

	desc "Update Binda::Repeater records assigning a default position value"
	task :add_video_feature => :environment do
		Binda::Repeater.where(position: nil).each do |repeater|
			repeater.update_attributes!(position: 0)
			puts "Binda::Repeater ##{repeater.id} updated"
		end
		puts
		puts "Binda has been updated successfully"
	end

end