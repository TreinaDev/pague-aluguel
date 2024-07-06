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
  document_number: CPF.generate
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
# areas comuns
churrasqueira = CommonArea.find_or_create_by!(name: 'Churrasqueira', description: 'Área de churrasqueira com piscina', max_capacity: 30,
                              usage_rules: 'Regras ainda não definidas', fee_cents: 250, condo_id: 20)
play = CommonArea.find_or_create_by!(name: 'Play', description: 'Play para eventos', max_capacity: 60,
                              usage_rules: 'Regras ainda não definidas', fee_cents: 300, condo_id: 20)
salao_festa = CommonArea.find_or_create_by!(name: 'Salão de festa', description: 'Área feita para eventos casuais', max_capacity: 40,
                              usage_rules: 'Proibido levar as mesas para fora do salão.', fee_cents: 400, condo_id: 20)
cinema = CommonArea.find_or_create_by!(name: 'Cinema', description: 'Guerreiros Saiajens', max_capacity: 60,
                              usage_rules: 'Proibido fumar na sala', fee_cents: 500, condo_id: 20)
CommonArea.find_or_create_by!(name: 'Sala de Jogos', description: 'Sala com mesa de ping pong, xadrez e sinuca.', max_capacity: 60,
                              usage_rules: 'Proibido fumar e beber na sala', fee_cents: 500, condo_id: 20)
CommonArea.find_or_create_by!(name: 'Área Gourmet', description: 'Salão para encontros, possui mesas e cadeiras', max_capacity: 60,
                              usage_rules: 'Proibido fumar na sala', fee_cents: 500, condo_id: 20)
CommonArea.find_or_create_by!(name: 'Salão com Piscina', description: 'Salão para festas com piscina privada para mais privacidade', max_capacity: 60,
                              usage_rules: 'Proibido fumar na sala', fee_cents: 500, condo_id: 20)
CommonArea.find_or_create_by!(name: 'Parquinho', description: 'Parquinho com balanço e castelo de plástico', max_capacity: 10,
                              usage_rules: 'Proibido crianças com mais de 10 anos', fee_cents: 500, condo_id: 20)
p "Created #{CommonArea.count} common areas"

CommonAreaFeeHistory.find_or_create_by!(fee_cents: 250, user: 'user1@example.com', common_area: churrasqueira, created_at: '2024-01-01')
CommonAreaFeeHistory.find_or_create_by!(fee_cents: 300, user: 'user2@example.com', common_area: play, created_at: '2024-02-01')
CommonAreaFeeHistory.find_or_create_by!(fee_cents: 400, user: 'user3@example.com', common_area: salao_festa, created_at: '2024-03-01')
CommonAreaFeeHistory.find_or_create_by!(fee_cents: 500, user: 'user4@example.com', common_area: cinema, created_at: '2024-04-01')
CommonAreaFeeHistory.find_or_create_by!(fee_cents: 255, user: 'user5@example.com', common_area: churrasqueira, created_at: '2024-05-01')
CommonAreaFeeHistory.find_or_create_by!(fee_cents: 305, user: 'user6@example.com', common_area: play, created_at: '2024-06-01')
CommonAreaFeeHistory.find_or_create_by!(fee_cents: 405, user: 'user7@example.com', common_area: salao_festa, created_at: '2024-07-01')
CommonAreaFeeHistory.find_or_create_by!(fee_cents: 505, user: 'user8@example.com', common_area: cinema, created_at: '2024-08-01')

# taxas fixas
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
