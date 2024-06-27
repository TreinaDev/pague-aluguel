# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Admin.create!(email: 'ikki.phoenix@seiya.com', password: 'phoenix123')

condo = Condo.create!(name: 'Sai de baixo', city: 'Rio de Janeiro')
second_condo = Condo.create!(name: 'Segundo Condomínio', city: 'Rio de Janeiro')

CommonArea.find_or_create_by!(name: 'TMNT', description: 'Teenage Mutant Ninja Turtles', max_capacity: 40,
                   usage_rules: 'Não lutar no salão', fee: 400, condo:)
CommonArea.find_or_create_by!(name: 'Saint Seiya', description: 'Os Cavaleiros dos zodíacos', max_capacity: 60,
                   usage_rules: 'Elevar o cosmos ao máximo.', fee: 500, condo:)

CommonArea.find_or_create_by!(name: 'Thundercats', description: 'Gatos Selvagens', max_capacity: 40,
                   usage_rules: 'Não pode dirigir o tanque dentro do salão', fee: 400, condo: second_condo)
CommonArea.find_or_create_by!(name: 'Dragon Ball Z', description: 'Guerreros Saiajens', max_capacity: 60,
                   usage_rules: 'Ressucitar o Kuririn.', fee: 500, condo: second_condo)
