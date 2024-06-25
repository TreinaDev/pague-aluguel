require 'rails_helper'

describe 'usuario loga como admin' do
  it 'com sucesso' do
    Admin.create!(
      email: 'example@mail.com',
      password: 'example123456',
      first_name: 'Fulano',
      last_name: 'Da Costa',
      document_number: '53071490003'
    )

    visit root_path
    click_on 'login'

    fill_in 'E-mail', with: 'example@mail.com'
    fill_in 'Senha', with: 'example123456'
    click_on 'Log in'

    expect(page).to have_content('Login efetuado com sucesso')
    expect(page).to have_content('Fulano Da Costa')
  end

  it 'falha quando login inexistente' do
    visit root_path
    click_on 'login'

    fill_in 'E-mail', with: 'example@mail.com'
    fill_in 'Senha', with: 'errado456'
    click_on 'Log in'

    expect(page).to have_content('E-mail ou senha inválidos.')
    expect(page).not_to have_content('Login efetuado com sucesso')
    expect(page).not_to have_content('Fulano Da Costa')
  end
end
