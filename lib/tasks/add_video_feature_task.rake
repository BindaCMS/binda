namespace :binda do 

	desc "Update binda_assets data to match new type structure"
	task :add_video_feature => :environment do
		Binda::Asset.all.each do |asset|
			next unless asset.type.nil?
			asset.update_attributes!(type: 'Binda::Image')
			asset.field_setting.update_attributes!(field_type: 'image') unless asset.field_setting.field_type == 'image'
			puts "Binda::Asset ##{asset.id} updated"
		end
		puts
		puts "Binda has been updated successfully"
	end

end