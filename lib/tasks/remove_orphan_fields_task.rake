namespace :binda do 

	desc "Remove fields which are pointing to non-existing field setting"
	task :remove_orphan_fields => :environment do
		Binda::FieldSetting.remove_orphan_fields
	end

end