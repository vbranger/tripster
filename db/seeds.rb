puts "Deleting users.."
User.destroy_all
puts "Creating users..."
victor = User.create(email: 'victor@gmail.com', password: '123456', first_name: 'Victor', last_name: 'Branger')
flo = User.create(email: 'florian@gmail.com', password: '123456', first_name: 'Florian', last_name: 'Leroy')
puts "Seed finished..."
