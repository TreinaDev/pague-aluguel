require 'rails_helper'

describe 'Sistema fora do ar' do
  it 'quando condominions está fora do ar' do
    FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    allow(Condo).to receive(:all).and_raise(Faraday::ConnectionFailed)

    visit root_path
    within 'nav' do
      click_on 'Login'
    end
    click_on 'Administrador'

    within 'form#new_admin' do
      fill_in 'E-mail', with: 'admin@mail.com'
      fill_in 'Senha', with: '123456'
      click_on 'Login'
    end

    expect(page).to have_content 'Sistema fora do ar'
    expect(page).to have_content 'Estamos trabalhando para reestabelecer os nossos servidores.'
  end
end
