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
    click_on 'Gerenciar Acesso aos Condomínios'
    check 'Condo Test'
    check 'Condo Admin Test'
    click_on 'Salvar'

    expect(current_path).to root_path
    expect(page).to have_content 'Acesso aos condomínios atualizado com sucesso'
    within('div#admin_2') do
      expect(page).to have_content 'Condo Test'
      expect(page).to have_content 'Condo Admin Test'
    end
    # expect(nathan.admin_associated_condos.condo_id).to include(1, 2)
    # expect(nathan.admin_associated_condos.condo_id).not_to include 3
  end
end
