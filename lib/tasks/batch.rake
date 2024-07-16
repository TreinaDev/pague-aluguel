namespace :batch do
  desc 'Gera faturas para cada unidade de todos condominios'
  task generate_bills: :environment do
    condos = Condo.all
    condos.each do |condo|
      units = Unit.find_all_by_condo(condo.id)
      units.each do |unit|
        GenerateMonthlyBillJob.perform_now(unit, condo.id)
      end
    end
  end
end
