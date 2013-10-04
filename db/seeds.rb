# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.delete_all
user = User.create(name: 'puxuan he', email: 'puxuan.he@cerner.com', password: '7962787', password_confirmation: '7962787', address: '3810 85th ter aptc', state: 'MO', city: 'Knasas city')
Asset.delete_all
