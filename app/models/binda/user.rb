module Binda
  class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable

	  def self.create_super_admin_user
			STDOUT.puts "What is your email? [mail@domain.com]"
		  username = STDIN.gets.strip
		  username = 'mail@domain.com' if username.blank?
			STDOUT.puts "What is your password? [password]"
		  password = STDIN.gets.strip
		  password = 'password' if password.blank?
		  User.create!( email: username, password: password, password_confirmation: password, is_superadmin: true )
	  end
  end
end
