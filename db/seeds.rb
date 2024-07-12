Value.destroy_all
BaseFee.destroy_all
SharedFee.destroy_all
# proprietarios
gian_lucca = PropertyOwner.new(
  email: 'gian@email.com',
  password: 'gian123',
  document_number: CPF.generate
)
gian_lucca.save(validate: false)

nathanael = PropertyOwner.new(
  email: 'nathanael@email.com',
  password: 'nathan123',
  document_number: CPF.generate
)
nathanael.save(validate: false)

lais = PropertyOwner.new(
  email: 'lais@email.com',
  password: 'lais123',
  document_number: CPF.generate
)
lais.save(validate: false)

p "Created #{PropertyOwner.count} property owners"

# admins
Admin.create!(
  email: 'kanzaki@myself.com',
  password: 'password123',
  first_name: 'Julia',
  last_name: 'Kanzaki',
  document_number: CPF.generate,
  super_admin: true
)

Admin.create!(
  email: 'matheus@mail.com',
  password: '123456', 
  first_name: 'Matheus',
  last_name: 'Bellucio',
  document_number: CPF.generate
)

Admin.create!(
  email: 'priscila@mail.com',
  password: '123456',
  first_name: 'Priscila',
  last_name: 'Sabino',
  document_number: CPF.generate
)

Admin.create!(
  email: 'angelo@maia.com',
  password: '123456',
  first_name: 'Angelo',
  last_name: 'Maia',
  document_number: CPF.generate
)

Admin.create!(
  email: 'arthur@mail.com',
  password: '123456',
  first_name: 'Arthur',
  last_name: 'Scortegagna',
  document_number: CPF.generate
)
p "Created #{Admin.count} admins"

# taxas fixas
base_fee1 = BaseFee.create!(name: 'Taxa de Condomínio',
                            description: 'Manutenção regular do prédio',
                            interest_rate: 2, late_fine: 10, limited: false,
                            charge_day: 25.days.from_now,
                            recurrence: :monthly, condo_id: 20)
Value.create!(price: 200, unit_type_id: 1, base_fee: base_fee1)
Value.create!(price: 200, unit_type_id: 2, base_fee: base_fee1)

base_fee2 = BaseFee.create!(name: 'Fundo de Reserva',
                            description: 'Destinado a cobrir despesas imprevistas',
                            interest_rate: 1, late_fine: 5, limited: true,
                            charge_day: 5.days.from_now, installments: 10,
                            recurrence: :bimonthly, condo_id: 20)
Value.create!(price: 300, unit_type_id: 1, base_fee: base_fee2)
Value.create!(price: 300, unit_type_id: 2, base_fee: base_fee2)

p "Created #{BaseFee.count} base fees"
# taxas compartilhadas
shared_fee1 = SharedFee.create!(description: 'Manutenção regular do prédio',
  issue_date: 10.days.from_now,
  total_value_cents: 20000,
  condo_id: 20)

shared_fee2 = SharedFee.create!(description: 'Fundo de Reserva para despesas imprevistas',
  issue_date: 20.days.from_now,
  total_value_cents: 30000,
  condo_id: 20)

shared_fee3 = SharedFee.create!(description: 'Taxa de Manutenção das áreas comuns',
  issue_date: 20.days.from_now,
  total_value_cents: 25000,
  condo_id: 20)

shared_fee4 = SharedFee.create!(description: 'Fundo Emergencial para reparos urgentes',
  issue_date: 6.days.from_now,
  total_value_cents: 50000,
  condo_id: 20)

shared_fee5 = SharedFee.create!(description: 'Taxa de Segurança do condomínio',
  issue_date: 10.days.from_now,
  total_value_cents: 15000,
  condo_id: 20)

shared_fee6 = SharedFee.create!(description: 'Taxa de Limpeza das áreas comuns',
  issue_date: 18.days.from_now,
  total_value_cents: 12000,
  condo_id: 20)

shared_fee7 = SharedFee.create!(description: 'Taxa de Jardinagem',
  issue_date: 5.days.from_now,
  total_value_cents: 18000,
  condo_id: 20)

shared_fee8 = SharedFee.create!(description: 'Taxa de Iluminação das áreas comuns',
  issue_date: 1.day.from_now,
  total_value_cents: 22000,
  condo_id: 20)

shared_fee9 = SharedFee.create!(description: 'Taxa de Água',
  issue_date: 12.days.from_now,
  total_value_cents: 25000,
  condo_id: 20)

shared_fee10 = SharedFee.create!(description: 'Taxa de Gás',
   issue_date: 10.days.from_now,
   total_value_cents: 20000,
   condo_id: 20)

p "Created #{SharedFee.count} shared fees"
