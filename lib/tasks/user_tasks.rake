namespace :binda do 

	desc "Create super admin user"
	task :create_superadmin_user => :environment do
		Binda::User.create_super_admin_user
	end

end