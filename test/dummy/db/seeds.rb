puts "========================================="
puts
puts "Create credential: "
puts
puts "      username:     admin@domain.com "
puts "      password:     password"
puts

Binda::User.create({ email: 'admin@domain.com', password: 'password' })

puts "========================================="
