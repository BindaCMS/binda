# desc "Explaining what the task does"
# task :binda do
#   # Task goes here
# end

desc "Create first user"
task :binda_create_initial_user => :environment do
	STDOUT.puts "What is your email? [mail@domain.com]"
  username = STDIN.gets.strip
  username = 'mail@domain.com' if username.blank?
	STDOUT.puts "What is your password? [password]"
  password = STDIN.gets.strip
  password = 'password' if password.blank?
  Binda::User.create!( email: username, password: password, password_confirmation: password, is_superadmin: true )
end