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

p "Created #{Admin.count} admins"

base_fee1 = BaseFee.create!(name: 'Taxa de Condomínio',
                            description: 'Manutenção regular do prédio',
                            late_payment: 2, late_fee: 10, fixed: true,
                            charge_day: 25.days.from_now,
                            recurrence: :monthly, condo_id: 1)
            Value.create!(price: 200, unit_type_id: 1, base_fee: base_fee1)
            Value.create!(price: 200, unit_type_id: 2, base_fee: base_fee1)

base_fee2 = BaseFee.create!(name: 'Fundo de Reserva',
                            description: 'Destinado a cobrir despesas imprevistas',
                            late_payment: 1, late_fee: 5, fixed: true,
                            charge_day: 5.days.from_now,
                            recurrence: :bimonthly, condo_id: 1)
            Value.create!(price: 300, unit_type_id: 1, base_fee: base_fee2)
            Value.create!(price: 300, unit_type_id: 2, base_fee: base_fee2)

p "Created #{BaseFee.count} base fees"
