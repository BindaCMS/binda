namespace :binda do

  desc "Remove fields which are pointing to non-existing field setting"
  task :remove_orphan_components => :environment do
    Binda::Component.remove_orphans
    puts
    puts "All orphans have been removed successfully"
  end

end