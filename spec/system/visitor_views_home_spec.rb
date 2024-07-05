require 'rails_helper'

describe 'Visitor views home' do
  xit 'successfully' do
    visit root_path

    expect(page).to have_content 'Cola?Bora!'
  end

  xit 'and prints message' do
    visit root_path

    fill_in 'Mensagem', with: 'Olá, pessoal!'
    click_on 'Imprimir'

    expect(page).not_to have_content 'Hello'
    expect(page).to have_css('p', text: 'Olá, pessoal!')
  end
end
