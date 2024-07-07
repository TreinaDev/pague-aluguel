require 'rails_helper'

describe 'admin vê admins registrados' do
  it 'e vê admins recentes' do
    admin = create(:admin, first_name: 'Matheus', last_name: 'Bellucio')
    create(:admin, first_name: 'Nathanael', last_name: 'Vieira', email: 'nathan@mail.com')
    create(:admin, first_name: 'Angelo', last_name: 'Maia', email: 'angelo@maia.com')
    create(:admin, first_name: 'Arthur', last_name: 'Scortegagna', email: 'arthur@mail.com')
    create(:admin, first_name: 'Julia', last_name: 'Kanzaki', email: 'julia@email.com')
    create(:admin, first_name: 'Lais', last_name: 'Almeida', email: 'lais@email.com')
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)

    login_as admin, scope: :admin
    visit root_path

    within('div#admins') do
      expect(page).to have_content 'Administradores'
      expect(page).to have_content 'Arthur Scortegagna'
      expect(page).to have_content 'Julia Kanzaki'
      expect(page).to have_content 'Lais Almeida'
      expect(page).not_to have_content 'Angelo Maia'
      expect(page).not_to have_content 'Nathanael Vieira'
      expect(page).not_to have_content 'Matheus Bellucio'
      expect(page).to have_link 'Mostrar todos'
    end
  end

  it 'e vê todos os admins cadastrados' do
    admin = create(:admin, first_name: 'Matheus', last_name: 'Bellucio')
    create(:admin, first_name: 'Nathanael', last_name: 'Vieira', email: 'nathan@mail.com')
    create(:admin, first_name: 'Angelo', last_name: 'Maia', email: 'angelo@maia.com')
    create(:admin, first_name: 'Arthur', last_name: 'Scortegagna', email: 'arthur@mail.com')
    create(:admin, first_name: 'Julia', last_name: 'Kanzaki', email: 'julia@email.com')
    create(:admin, first_name: 'Lais', last_name: 'Almeida', email: 'lais@email.com')
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)

    login_as admin, scope: :admin
    visit root_path
    within('div#admins') do
      click_on 'Mostrar todos'

      expect(page).to have_content 'Administradores'
      expect(page).to have_content 'Arthur Scortegagna'
      expect(page).to have_content 'Julia Kanzaki'
      expect(page).to have_content 'Lais Almeida'
      expect(page).to have_content 'Angelo Maia'
      expect(page).to have_content 'Nathanael Vieira'
      expect(page).to have_link 'Ocultar'
      expect(page).not_to have_content 'Matheus Bellucio'
    end
  end
end
