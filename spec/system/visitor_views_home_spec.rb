require 'rails_helper'

describe 'Visitor views home' do
  it 'successfully' do
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)

    visit root_path

    within('nav') do
      expect(page).to have_css 'img[src*="logo-pa"]'
      expect(page).to have_content 'LOGIN'
    end
    expect(page).to have_css 'img[src*="pa-banner"]'
  end
end
