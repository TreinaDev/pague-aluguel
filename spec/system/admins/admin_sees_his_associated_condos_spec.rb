require 'rails_helper'

describe 'admin vê seus condomínios associados' do
  it 'com sucesso e ve apenas o associado a ele' do
    create(:admin, super_admin: true)
    nathan = create(:admin, first_name: 'Nathanael', last_name: 'Vieira', email: 'nathan@mail.com', super_admin: false)
    condos = []
    condos << condo1 = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    condos << Condo.new(id: 2, name: 'Condo Admin Test', city: 'ABC City')
    condos << Condo.new(id: 3, name: 'Condo Outro Test', city: 'Rio de Janeiro')
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condo1)
    AssociatedCondo.create!(admin: nathan, condo_id: 1)

    login_as nathan, scope: :admin
    visit root_path

    expect(page).to have_content 'Condo Test'
    expect(page).to have_content 'City Test'
    expect(page).not_to have_content 'Condo Admin Test'
    expect(page).not_to have_content 'Condo Outro Test'
  end

  it 'e vê mais de um condominio associado à ele' do
    create(:admin, super_admin: true)
    nathan = create(:admin, first_name: 'Nathanael', last_name: 'Vieira', email: 'nathan@mail.com', super_admin: false)
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    condos << Condo.new(id: 2, name: 'Condo Admin Test', city: 'ABC City')
    condos << Condo.new(id: 3, name: 'Condo Outro Test', city: 'Rio de Janeiro')
    allow(Condo).to receive(:all).and_return(condos)
    AssociatedCondo.create!(admin: nathan, condo_id: 1)
    AssociatedCondo.create!(admin: nathan, condo_id: 2)

    login_as nathan, scope: :admin
    visit root_path

    expect(page).to have_content 'Condo Test'
    expect(page).to have_content 'City Test'
    expect(page).to have_content 'Condo Admin Test'
    expect(page).to have_content 'ABC City'
    expect(page).not_to have_content 'Condo Outro Test'
    expect(page).not_to have_content 'Rio de Janeiro'
  end

  it 'e não vê os associados à outro admin' do
    create(:admin, super_admin: true)
    nathan = create(:admin, first_name: 'Nathanael', last_name: 'Vieira', email: 'nathan@mail.com', super_admin: false)
    snake = create(:admin, first_name: 'Big', last_name: 'Boss', email: 'bigboss@mail.com', super_admin: false)
    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    condos << Condo.new(id: 2, name: 'Condo Admin Test', city: 'ABC City')
    condos << Condo.new(id: 3, name: 'Condo Outro Test', city: 'Rio de Janeiro')
    allow(Condo).to receive(:all).and_return(condos)
    AssociatedCondo.create!(admin: nathan, condo_id: 1)
    AssociatedCondo.create!(admin: snake, condo_id: 2)

    login_as nathan, scope: :admin
    visit root_path

    expect(page).to have_content 'Condo Test'
    expect(page).to have_content 'City Test'
    expect(page).not_to have_content 'Condo Admin Test'
    expect(page).not_to have_content 'ABC City'
    expect(page).not_to have_content 'Condo Outro Test'
    expect(page).not_to have_content 'Rio de Janeiro'
  end
end
