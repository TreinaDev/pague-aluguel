require 'rails_helper'
require 'whenever'

describe 'Schedule' do
  it 'envia fatura todo dia primeiro de cada mês' do
    expected = '0 0 1 * *'
    expect(cron_output).to include(expected)
  end
end

def cron_output
  Whenever::JobList.new(file: Rails.root.join('config/schedule.rb').to_s)
                   .generate_cron_output
                   .gsub(Dir.pwd, '')
end
