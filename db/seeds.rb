admin = Admin.create!(email: 'email@email.com', password: '123456')
condo1 = Condo.create!(name: 'Prédio lindo', city: 'Cidade Maravilhosa')
unit_type1 = UnitType.create!(description: 'Tipo de unidade 1',
                  area: 30, ideal_fraction: 0.4, condo: condo1)
unit_type2 = UnitType.create!(description: 'Tipo de unidade 2',
                  area: 60, ideal_fraction: 0.9, condo: condo1)
Admin.create!(
  email: 'admin@mail.com',
  password: '123456',
  first_name: 'Fulano',
  last_name: 'Da Costa',
  document_number: CPF.generate
)
