require 'rails_helper'

describe 'admin cria taxa fixa' do
  it 'e deve estar logado' do
    visit new_base_fee_path

    expect(current_path).to eq new_admin_session_path
  end
end
