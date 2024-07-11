require 'rails_helper'

describe 'Super admin gerencia o acesso de outros admins aos condomínios' do
  it 'com sucesso' do
    admin = create(:admin, super_admin: true)
    nathan = create(:admin, first_name: 'Nathanael', last_name: 'Vieira', email: 'nathan@mail.com')

    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    condos << Condo.new(id: 2, name: 'Condo Admin Test', city: 'ABC City')
    condos << Condo.new(id: 3, name: 'Condo Outro Test', city: 'Rio de Janeiro')
    allow(Condo).to receive(:all).and_return(condos)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Nathanael'
    click_on 'gerenciar acesso aos condomínios'
    check 'Condo Test'
    check 'Condo Admin Test'
    click_on 'Salvar'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Acesso aos condomínios atualizado com sucesso'
    expect(nathan.associated_condos.pluck(:condo_id)).to include(1, 2)
    expect(nathan.associated_condos.pluck(:condo_id)).not_to include(3)
  end

  it 'e visualiza admin com condomínios associados' do
    admin = create(:admin, super_admin: true)
    nathan = create(:admin, first_name: 'Nathanael', last_name: 'Vieira', email: 'nathan@mail.com')
    condos = []
    condos << condo1 = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    condos << Condo.new(id: 2, name: 'Condo Admin Test', city: 'ABC City')
    condos << Condo.new(id: 3, name: 'Condo Outro Test', city: 'Rio de Janeiro')
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condo1)
    AssociatedCondo.create!(admin: nathan, condo_id: 1)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Nathanael'

    expect(current_path).to eq root_path
    expect(nathan.associated_condos.map(&:id)).to include(1)
    within('div#admin_2') do
      expect(page).to have_content 'Condo Test'
      expect(page).not_to have_content 'Condo Admin Test'
      expect(page).not_to have_content 'Condo Outro Test'
    end
  end
end
