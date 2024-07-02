Admin.create!(email: 'ikki.phoenix@seiya.com', password: 'phoenix123', first_name: 'Ikki', last_name: 'Phoenix',
              document_number: CPF.generate)

Value.destroy_all
BaseFee.destroy_all
SharedFee.destroy_all
UnitType.destroy_all
Condo.destroy_all

#Admin
Admin.create!(
  email: 'admin@mail.com',
  password: '123456',
  first_name: 'Fulano',
  last_name: 'Da Costa',
  document_number: CPF.generate
)

condo = Condo.create!(name: 'Sai de baixo', city: 'Rio de Janeiro')

second_condo = Condo.create!(name: 'Segundo Condomínio', city: 'Rio de Janeiro')

CommonArea.find_or_create_by!(name: 'Churrasqueira', description: 'Área de churrasqueira com piscina', max_capacity: 30,
                              usage_rules: 'Regras ainda não definidas', fee_cents: 250, condo:)
CommonArea.find_or_create_by!(name: 'Play', description: 'Play para eventos', max_capacity: 60,
                              usage_rules: 'Regras ainda não definidas', fee_cents: 300, condo:)

CommonArea.find_or_create_by!(name: 'Salão de festa', description: 'Área feita para eventos casuais', max_capacity: 40,
                              usage_rules: 'Proibido levar as mesas para fora do salão.', fee_cents: 400, condo: second_condo)
CommonArea.find_or_create_by!(name: 'Cinema', description: 'Guerreiros Saiajens', max_capacity: 60,
                              usage_rules: 'Proibido fumar na sala', fee_cents: 500, condo: second_condo)

p "Created #{Admin.count} admins"

#Condomínios
condo1 = Condo.create!(name: 'Prédio lindo', city: 'Cidade Maravilhosa')

p "Created #{Condo.count} condos"

#Tipos de unidades
unit_type1 = UnitType.create!(description: 'Tipo de unidade 1',
                              area: 30, ideal_fraction: 0.4, condo: condo1)

unit_type2 = UnitType.create!(description: 'Tipo de unidade 2',
                              area: 60, ideal_fraction: 0.9, condo: condo1)

p "Created #{UnitType.count} unit types"

#Taxas Fixas
base_fee1 = BaseFee.create!(name: 'Taxa de Condomínio',
                            description: 'Manutenção regular do prédio',
                            late_payment: 2, late_fee: 10, fixed: true,
                            charge_day: 25.days.from_now,
                            recurrence: :monthly, condo: condo1)
            Value.create!(price: 200, unit_type: unit_type1, base_fee: base_fee1)
            Value.create!(price: 200, unit_type: unit_type2, base_fee: base_fee1)

base_fee2 = BaseFee.create!(name: 'Fundo de Reserva',
                            description: 'Destinado a cobrir despesas imprevistas',
                            late_payment: 1, late_fee: 5, fixed: true,
                            charge_day: 5.days.from_now,
                            recurrence: :bimonthly, condo: condo1)
            Value.create!(price: 300, unit_type: unit_type1, base_fee: base_fee2)
            Value.create!(price: 300, unit_type: unit_type2, base_fee: base_fee2)

p "Created #{BaseFee.count} base fees"
