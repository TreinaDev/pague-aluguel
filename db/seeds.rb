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
                              usage_rules: 'Regras ainda não definidas', fee_cents: 250, condo_id: 20)
CommonArea.find_or_create_by!(name: 'Play', description: 'Play para eventos', max_capacity: 60,
                              usage_rules: 'Regras ainda não definidas', fee_cents: 300, condo_id: 20)

CommonArea.find_or_create_by!(name: 'Salão de festa', description: 'Área feita para eventos casuais', max_capacity: 40,
                              usage_rules: 'Proibido levar as mesas para fora do salão.', fee_cents: 400, condo_id: 20)
CommonArea.find_or_create_by!(name: 'Cinema', description: 'Guerreiros Saiajens', max_capacity: 60,
                              usage_rules: 'Proibido fumar na sala', fee_cents: 500, condo_id: 20)
CommonArea.find_or_create_by!(name: 'Sala de Jogos', description: 'Sala com mesa de ping pong, xadrez e sinuca.', max_capacity: 60,
                              usage_rules: 'Proibido fumar e beber na sala', fee_cents: 500, condo_id: 20)
CommonArea.find_or_create_by!(name: 'Área Gourmet', description: 'Salão para encontros, possui mesas e cadeiras', max_capacity: 60,
                              usage_rules: 'Proibido fumar na sala', fee_cents: 500, condo_id: 20)
CommonArea.find_or_create_by!(name: 'Salão com Piscina', description: 'Salão para festas com piscina privada para mais privacidade', max_capacity: 60,
                              usage_rules: 'Proibido fumar na sala', fee_cents: 500, condo_id: 20)
CommonArea.find_or_create_by!(name: 'Parquinho', description: 'Parquinho com balanço e castelo de plástico', max_capacity: 10,
                              usage_rules: 'Proibido crianças com mais de 10 anos', fee_cents: 500, condo_id: 20)

p "Created #{Admin.count} admins"

#Taxas Fixas

base_fee1 = BaseFee.create!(name: 'Taxa de Condomínio',
                            description: 'Manutenção regular do prédio',
                            interest_rate: 2, late_fine: 10, fixed: true,
                            charge_day: 25.days.from_now,
                            recurrence: :monthly, condo_id: 20)
            Value.create!(price: 200, unit_type_id: 1, base_fee: base_fee1)
            Value.create!(price: 200, unit_type_id: 2, base_fee: base_fee1)

base_fee2 = BaseFee.create!(name: 'Fundo de Reserva',
                            description: 'Destinado a cobrir despesas imprevistas',
                            interest_rate: 1, late_fine: 5, fixed: true,
                            charge_day: 5.days.from_now,
                            recurrence: :bimonthly, condo_id: 20)
            Value.create!(price: 300, unit_type_id: 1, base_fee: base_fee2)
            Value.create!(price: 300, unit_type_id: 2, base_fee: base_fee2)

p "Created #{BaseFee.count} base fees"

# db/seeds.rb

# Seed 1
shared_fee1 = SharedFee.create!(description: 'Manutenção regular do prédio',
  issue_date: 10.days.from_now,
  total_value_cents: 20000,
  condo_id: 20)
SharedFeeFraction.create!(value_cents: 10000, unit_id: 1, shared_fee_id: shared_fee1.id)
SharedFeeFraction.create!(value_cents: 10000, unit_id: 2, shared_fee_id: shared_fee1.id)

# Seed 2
shared_fee2 = SharedFee.create!(description: 'Fundo de Reserva para despesas imprevistas',
  issue_date: 20.days.from_now,
  total_value_cents: 30000,
  condo_id: 20)
SharedFeeFraction.create!(value_cents: 15000, unit_id: 1, shared_fee_id: shared_fee2.id)
SharedFeeFraction.create!(value_cents: 15000, unit_id: 2, shared_fee_id: shared_fee2.id)

# Seed 3
shared_fee3 = SharedFee.create!(description: 'Taxa de Manutenção das áreas comuns',
  issue_date: 20.days.from_now,
  total_value_cents: 25000,
  condo_id: 20)
SharedFeeFraction.create!(value_cents: 12500, unit_id: 1, shared_fee_id: shared_fee3.id)
SharedFeeFraction.create!(value_cents: 12500, unit_id: 2, shared_fee_id: shared_fee3.id)

# Seed 4
shared_fee4 = SharedFee.create!(description: 'Fundo Emergencial para reparos urgentes',
  issue_date: 6.days.from_now,
  total_value_cents: 50000,
  condo_id: 20)
SharedFeeFraction.create!(value_cents: 25000, unit_id: 1, shared_fee_id: shared_fee4.id)
SharedFeeFraction.create!(value_cents: 25000, unit_id: 2, shared_fee_id: shared_fee4.id)

# Seed 5
shared_fee5 = SharedFee.create!(description: 'Taxa de Segurança do condomínio',
  issue_date: 10.days.from_now,
  total_value_cents: 15000,
  condo_id: 20)
SharedFeeFraction.create!(value_cents: 7500, unit_id: 1, shared_fee_id: shared_fee5.id)
SharedFeeFraction.create!(value_cents: 7500, unit_id: 2, shared_fee_id: shared_fee5.id)

# Seed 6
shared_fee6 = SharedFee.create!(description: 'Taxa de Limpeza das áreas comuns',
  issue_date: 18.days.from_now,
  total_value_cents: 12000,
  condo_id: 20)
SharedFeeFraction.create!(value_cents: 6000, unit_id: 1, shared_fee_id: shared_fee6.id)
SharedFeeFraction.create!(value_cents: 6000, unit_id: 2, shared_fee_id: shared_fee6.id)

# Seed 7
shared_fee7 = SharedFee.create!(description: 'Taxa de Jardinagem',
  issue_date: 5.days.from_now,
  total_value_cents: 18000,
  condo_id: 20)
SharedFeeFraction.create!(value_cents: 9000, unit_id: 1, shared_fee_id: shared_fee7.id)
SharedFeeFraction.create!(value_cents: 9000, unit_id: 2, shared_fee_id: shared_fee7.id)

# Seed 8
shared_fee8 = SharedFee.create!(description: 'Taxa de Iluminação das áreas comuns',
  issue_date: 1.day.from_now,
  total_value_cents: 22000,
  condo_id: 20)
SharedFeeFraction.create!(value_cents: 11000, unit_id: 1, shared_fee_id: shared_fee8.id)
SharedFeeFraction.create!(value_cents: 11000, unit_id: 2, shared_fee_id: shared_fee8.id)

# Seed 9
shared_fee9 = SharedFee.create!(description: 'Taxa de Água',
  issue_date: 12.days.from_now,
  total_value_cents: 25000,
  condo_id: 20)
SharedFeeFraction.create!(value_cents: 12500, unit_id: 1, shared_fee_id: shared_fee9.id)
SharedFeeFraction.create!(value_cents: 12500, unit_id: 2, shared_fee_id: shared_fee9.id)

# Seed 10
shared_fee10 = SharedFee.create!(description: 'Taxa de Gás',
   issue_date: 10.days.from_now,
   total_value_cents: 20000,
   condo_id: 20)
SharedFeeFraction.create!(value_cents: 10000, unit_id: 1, shared_fee_id: shared_fee10.id)
SharedFeeFraction.create!(value_cents: 10000, unit_id: 2, shared_fee_id: shared_fee10.id)

p "Created #{SharedFee.count} shared fees"
