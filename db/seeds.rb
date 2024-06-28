admin = Admin.create!(email: 'email@email.com', password: '123456')
condo1 = Condo.create!(name: 'Prédio lindo', city: 'Cidade Maravilhosa')
unit_type1 = UnitType.create!(description: 'Unit type 1',
                  area: 30, ideal_fraction: 0.4, condo: condo1)
unit_type2 = UnitType.create!(description: 'Unit type 2',
                  area: 60, ideal_fraction: 0.9, condo: condo1)
