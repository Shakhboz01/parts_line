# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create(email: 'admin@gmail.com', password: 'admin222', role: 0, name: 'admin')
User.create(email: 'asad@gmail.com', password: '111111', role: 0, name: 'asad')
CurrencyRate.create(rate: 12000.00, finished_at: nil)
ProductCategory.create(name: 'Прочие')
Provider.create(name: 'Клиент')
