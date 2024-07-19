Value.destroy_all
BaseFee.destroy_all
SharedFee.destroy_all
# proprietarios
gian_lucca = PropertyOwner.new(
  email: 'gian@email.com',
  password: 'gian123',
  first_name: 'Gian',
  last_name: 'Lucca',
  document_number: '077.497.020-08'
)
gian_lucca.save(validate: false)

nathanael = PropertyOwner.new(
  email: 'nathanael@email.com',
  password: 'nathan123',
  first_name: 'Nathaniel',
  last_name: 'Vieira',
  document_number: CPF.generate
)
nathanael.save(validate: false)

lais = PropertyOwner.new(
  email: 'lais@email.com',
  password: 'lais123',
  first_name: 'Lais',
  last_name: 'Almeida',
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
  document_number: CPF.generate,
  super_admin: true
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
                            recurrence: :monthly, condo_id: 2)
Value.create!(price: 200, unit_type_id: 1, base_fee: base_fee1)
Value.create!(price: 200, unit_type_id: 2, base_fee: base_fee1)

base_fee2 = BaseFee.create!(name: 'Fundo de Reserva',
                            description: 'Destinado a cobrir despesas imprevistas',
                            interest_rate: 1, late_fine: 5, limited: true,
                            charge_day: 5.days.from_now, installments: 10,
                            recurrence: :bimonthly, condo_id: 2)
Value.create!(price: 300, unit_type_id: 1, base_fee: base_fee2)
Value.create!(price: 300, unit_type_id: 2, base_fee: base_fee2)

base_fee3 = BaseFee.new(name: 'Taxa de Gás',
                            description: 'Gás encanado do prédio',
                            interest_rate: 2, late_fine: 10, limited: false,
                            charge_day: 3.months.ago,
                            recurrence: :monthly, condo_id: 2)
                            base_fee3.save(validate: false)
Value.create!(price: 200, unit_type_id: 1, base_fee: base_fee3)
Value.create!(price: 200, unit_type_id: 2, base_fee: base_fee3)

base_fee97 = BaseFee.new(name: 'Fundo de Pintura',
                            description: 'Destinado a pintar as áreas comuns',
                            interest_rate: 1, late_fine: 5, limited: true,
                            charge_day: 5.months.ago, installments: 10,
                            recurrence: :bimonthly, condo_id: 2,
                            status: :canceled)
                            base_fee97.save(validate: false)
Value.create!(price: 300, unit_type_id: 1, base_fee: base_fee97)
Value.create!(price: 300, unit_type_id: 2, base_fee: base_fee97)

p "Created #{BaseFee.count} base fees"

# taxas compartilhadas
shared_fee1 = SharedFee.new(description: 'Manutenção regular do prédio',
                  issue_date: 5.months.ago,
                  total_value_cents: 20_000,
                  condo_id: 2)
                  shared_fee1.save(validate: false)

shared_fee2 = SharedFee.new(description: 'Fundo de Reserva para despesas imprevistas',
                  issue_date: 20.days.ago,
                  total_value_cents: 30_000,
                  condo_id: 2)
                  shared_fee2.save(validate: false)

SharedFee.create!(description: 'Taxa de Manutenção das áreas comuns',
                  issue_date: 20.days.from_now,
                  total_value_cents: 25_000,
                  condo_id: 2, status: :canceled)

SharedFee.create!(description: 'Fundo Emergencial para reparos urgentes',
                  issue_date: 6.days.from_now,
                  total_value_cents: 50_000,
                  condo_id: 2)

SharedFee.create!(description: 'Taxa de Segurança do condomínio',
                  issue_date: 10.days.from_now,
                  total_value_cents: 15_000,
                  condo_id: 2)

SharedFee.create!(description: 'Taxa de Limpeza das áreas comuns',
                  issue_date: 18.days.from_now,
                  total_value_cents: 12_000,
                  condo_id: 2)

SharedFee.create!(description: 'Taxa de Jardinagem',
                  issue_date: 5.days.from_now,
                  total_value_cents: 18_000,
                  condo_id: 2)

SharedFee.create!(description: 'Taxa de Iluminação das áreas comuns',
                  issue_date: 1.day.from_now,
                  total_value_cents: 22_000,
                  condo_id: 2)

SharedFee.create!(description: 'Taxa de Água',
                  issue_date: 12.days.from_now,
                  total_value_cents: 25_000,
                  condo_id: 2)

SharedFee.create!(description: 'Taxa de Gás',
                  issue_date: 10.days.from_now,
                  total_value_cents: 20_000,
                  condo_id: 2)

p "Created #{SharedFee.count} shared fees"

SingleCharge.create!(unit_id: 97, value_cents: 150_00,
                    issue_date: 15.days.from_now, description: 'Taxa de pintura',
                    charge_type: :fine, condo_id: 2, status: 0)

SingleCharge.create!(unit_id: 97, value_cents: 250_00,
                    issue_date: 10.days.from_now, description: 'Reparos na área comum',
                    charge_type: :fine, condo_id: 2, status: 5)

SingleCharge.create!(unit_id: 97, value_cents: 500_00,
                    issue_date: 5.days.from_now, description: 'Reparos de elevador',
                    charge_type: :fine, condo_id: 2, status: 0)

SingleCharge.create!(unit_id: 97, value_cents: 300_00,
                    issue_date: 7.days.from_now, description: 'Taxa de limpeza',
                    charge_type: :fine, condo_id: 2, status: 0)

SingleCharge.create!(unit_id: 97, value_cents: 100_00,
                    issue_date: 25.days.from_now, description: 'Reforma no jardim',
                    charge_type: :fine, condo_id: 2, status: 0)

SingleCharge.create!(unit_id: 97, value_cents: 9750_00,
                    issue_date: 30.days.from_now, description: 'Reparos elétricos',
                    charge_type: :fine, condo_id: 2, status: 0)

p "Created #{SingleCharge.count} single charge"

Bill.create!(
  unit_id: 97,
  condo_id: 2,
  base_fee_value_cents: 1000_00,
  shared_fee_value_cents: 2100_00,
  total_value_cents: 3100_00,
  issue_date: Time.zone.today.beginning_of_month,
  due_date: 10.days.from_now,
  status: :pending
)

Bill.create!(
  unit_id: 97,
  condo_id: 2,
  base_fee_value_cents: 1300_00,
  shared_fee_value_cents: 2000_00,
  total_value_cents: 3300_00,
  issue_date: 30.days.ago.beginning_of_month,
  due_date: 20.days.ago,
  status: :awaiting
)

Bill.create!(
  unit_id: 97,
  condo_id: 2,
  base_fee_value_cents: 1000_00,
  shared_fee_value_cents: 2000_00,
  total_value_cents: 3000_00,
  issue_date: 60.days.ago.beginning_of_month,
  due_date: 50.days.ago,
  status: :paid
)

Bill.create!(
  unit_id: 1,
  condo_id: 1,
  base_fee_value_cents: 250_00,
  shared_fee_value_cents: 750_00,
  total_value_cents: 1000_00,
  issue_date: Time.zone.today.beginning_of_month,
  due_date: 10.days.from_now,
  status: :pending
)

Bill.create!(
  unit_id: 1,
  condo_id: 1,
  base_fee_value_cents: 300_00,
  shared_fee_value_cents: 1000_00,
  total_value_cents: 1300_00,
  issue_date: 30.days.ago.beginning_of_month,
  due_date: 20.days.ago,
  status: :awaiting
)

Bill.create!(
  unit_id: 1,
  condo_id: 1,
  base_fee_value_cents: 270_00,
  shared_fee_value_cents: 1000_00,
  total_value_cents: 1270_00,
  issue_date: 60.days.ago.beginning_of_month,
  due_date: 50.days.ago,
  status: :paid
)

Bill.create!(
  unit_id: 1,
  condo_id: 1,
  base_fee_value_cents: 1000_00,
  shared_fee_value_cents: 500_00,
  total_value_cents: 1500_00,
  issue_date: 90.days.ago.beginning_of_month,
  due_date: 80.days.ago,
  status: :paid
)

Bill.create!(
  unit_id: 1,
  condo_id: 1,
  base_fee_value_cents: 1000_00,
  shared_fee_value_cents: 510_00,
  total_value_cents: 1510_00,
  issue_date: 120.days.ago.beginning_of_month,
  due_date: 110.days.ago,
  status: :paid
)

p "Created 3 bills for 314.787.200-93"
p "Created 5 bills for 458.456.480-92"

Receipt.create!(bill_id: 2, file: Rails.root.join('app', 'assets', 'images', 'cupom-fiscal.jpg').open)
Receipt.create!(bill_id: 3, file: Rails.root.join('app', 'assets', 'images', 'comprovante-pg.jpg').open)
Receipt.create!(bill_id: 5, file: Rails.root.join('app', 'assets', 'images', 'cupom-fiscal.jpg').open)
Receipt.create!(bill_id: 6, file: Rails.root.join('app', 'assets', 'images', 'cupom-fiscal.jpg').open)
Receipt.create!(bill_id: 7, file: Rails.root.join('app', 'assets', 'images', 'cupom-fiscal.jpg').open)
Receipt.create!(bill_id: 8, file: Rails.root.join('app', 'assets', 'images', 'cupom-fiscal.jpg').open)

p "Created #{Receipt.count} receipts"
