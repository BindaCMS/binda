namespace :binda do 

	desc "Add Default Helpers class to your application"
	task :add_default_helpers_class => :environment do
    puts "Setting up default helpers"
    sh "rails generate model B --no-migration --parent=::Binda::B"
    puts "Default helpers has been set up."
    puts 
	end

end