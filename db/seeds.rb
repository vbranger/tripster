# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts "Creating users..."
victor = User.create(email: 'victor@gmail.com', password: '123456')
chaoui = User.create(email: 'chaoui@gmail.com', password: '123456')