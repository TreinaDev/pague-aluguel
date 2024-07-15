every '0 0 1 * *' do
  rake 'batch:generate_bills'
end
