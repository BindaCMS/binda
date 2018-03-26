namespace :binda do
	desc "Update all images with file details"
	task :update_image_details => :environment do
		Binda::Image.all.each do |image|
			image.register_details
		end
	end
end