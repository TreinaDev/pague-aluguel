Admin.create!(
  email: 'admin@mail.com',
  password: '123456',
  first_name: 'Fulano',
  last_name: 'Da Costa',
  document_number: CPF.generate
)
