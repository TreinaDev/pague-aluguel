
  it 'e deve estar autenticado' do
    visit condos_path

    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
    expect(current_path).to eq new_admin_session_path
  end

  it 'e não existem condomínios registrados' do
    admin = create(:admin)

    response = double('response', success?: true, body: '[]')
    allow(Faraday).to receive(:get).with('http://127.0.0.1:3000/api/v1/condos').and_return(response)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Lista de Condomínios'

    expect(page).to have_content 'Não existem condomínios registrados.'
  end
end
