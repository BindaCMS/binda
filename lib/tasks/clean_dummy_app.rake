namespace :binda do

  desc "Update dummy app migrations and schema"
  task :update_dummy => :environment do
    puts "---------------------"
    puts "Remove current schema"
    puts "---------------------"
    sh "cd #{Rails.root} && rm -r db/schema.rb"
    puts ""
    puts "----------------------------------------------"
    puts "Drop and create new dev db, then install Binda"
    puts "----------------------------------------------"
    sh "rails db:drop && rails db:create && rails generate binda:install"
    puts ""
    puts "--------------------------------------------------"
    puts "Remove old dummy migrations and devise config file"
    puts "--------------------------------------------------"
    sh "rm -rf #{Rails.root}/db/migrate && rm -rf #{Rails.root}/config/initializers/devise_backup_*.rb &&
              cd #{Rails.root}/../.."
    puts ""
    puts "------------------------"
    puts "Create new clean test db"
    puts "------------------------"
    sh "rails db:drop RAILS_ENV=test && rails db:create RAILS_ENV=test && rails db:migrate RAILS_ENV=test"
    puts ""
    puts "------------------------"
    puts "Dummy updated"
    puts "------------------------"
  end

end