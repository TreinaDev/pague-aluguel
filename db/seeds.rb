Admin.create!(email: 'ikki.phoenix@seiya.com', password: 'phoenix123', first_name: 'Ikki', last_name: 'Phoenix',
              document_number: CPF.generate)

Value.destroy_all
BaseFee.destroy_all
SharedFee.destroy_all

Admin.create!(
  email: 'admin@mail.com',
  password: '123456',
  first_name: 'Fulano',
  last_name: 'Da Costa',
  document_number: CPF.generate
)

Admin.create!(
  email: '1@mail.com',
  password: '123456',
  first_name: 'Bruna',
  last_name: 'Alvares',
  document_number: CPF.generate
)

Admin.create!(
  email: '2@mail.com',
  password: '123456',
  first_name: 'Jair',
  last_name: 'Nuno',
  document_number: CPF.generate
)

Admin.create!(
  email: '3@mail.com',
  password: '123456',
  first_name: 'Leandro',
  last_name: 'Porta',
  document_number: CPF.generate
)
p "Created #{Admin.count} admins"

CommonArea.find_or_create_by!(name: 'Churrasqueira', description: 'Área de churrasqueira com piscina', max_capacity: 30,
                              usage_rules: 'Regras ainda não definidas', fee_cents: 250)
CommonArea.find_or_create_by!(name: 'Play', description: 'Play para eventos', max_capacity: 60,
                              usage_rules: 'Regras ainda não definidas', fee_cents: 300)

CommonArea.find_or_create_by!(name: 'Salão de festa', description: 'Área feita para eventos casuais', max_capacity: 40,
                              usage_rules: 'Proibido levar as mesas para fora do salão.', fee_cents: 400)
CommonArea.find_or_create_by!(name: 'Cinema', description: 'Guerreiros Saiajens', max_capacity: 60,
                              usage_rules: 'Proibido fumar na sala', fee_cents: 500)

p "Created #{Admin.count} admins"

#Taxas Fixas

base_fee1 = BaseFee.create!(name: 'Taxa de Condomínio',
                            description: 'Manutenção regular do prédio',
                            interest_rate: 2, late_fine: 10, fixed: true,
                            charge_day: 25.days.from_now,
                            recurrence: :monthly, condo_id: 1)
            Value.create!(price: 200, unit_type_id: 1, base_fee: base_fee1)
            Value.create!(price: 200, unit_type_id: 2, base_fee: base_fee1)

base_fee2 = BaseFee.create!(name: 'Fundo de Reserva',
                            description: 'Destinado a cobrir despesas imprevistas',
                            interest_rate: 1, late_fine: 5, fixed: true,
                            charge_day: 5.days.from_now,
                            recurrence: :bimonthly, condo_id: 1)
            Value.create!(price: 300, unit_type_id: 1, base_fee: base_fee2)
            Value.create!(price: 300, unit_type_id: 2, base_fee: base_fee2)

p "Created #{BaseFee.count} base fees"
