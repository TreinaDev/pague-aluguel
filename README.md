# PagueAluguel - Sistema de Cobrança de Aluguéis e Taxas de Condomínio

![Static Badge](https://img.shields.io/badge/Ruby_3.2.2-CC342D?style=for-the-badge&logo=ruby&logoColor=white)
![Static Badge](https://img.shields.io/badge/Ruby_on_Rails_7.1.2-CC0000?style=for-the-badge&logo=ruby-on-rails&logoColor=white)
![Bootstrap](https://img.shields.io/badge/bootstrap-%238511FA.svg?style=for-the-badge&logo=bootstrap&logoColor=white)

![Static Badge](https://img.shields.io/badge/COBERTURA_DE_TESTES-100%25-blue)
![Static Badge](https://img.shields.io/badge/STATUS-EM_DESENVOLVIMENTO-green)

### Tópicos

▶️ [Descrição do projeto](#descrição-do-projeto)

▶️ [Funcionalidades](#funcionalidades)

▶️ [Gems utilizadas](#gems-utilizadas)

▶️ [APIs](#apis)

▶️ [Pré-requisitos](#pré-requisitos)

▶️ [Como executar a aplicação](#como-executar-a-aplicação)

▶️ [Como executar os testes](#como-executar-os-testes)

▶️ [Navegação](#navegação)

▶️ [Criação de Contas Fictícias](#criação-de-contas-fictícias)

▶️ [Desenvolvedores](#desenvolvedores)

## Descrição do Projeto

📍 PagueAluguel é uma aplicação para o envio de cobranças de aluguel, taxas de condomínio e outras cobranças relacionadas aos imóveis de um condomínio. O sistema é utilizado por usuários proprietários de apartamentos do condomínio e usuários com perfil administrativo. A aplicação está totalmente integrada com a aplicação [CondoMinions](https://github.com/TreinaDev/condominions) para fazer a validação de dados de unidades e para garantir que os moradores recebam as cobranças mensais de suas unidades.

## Funcionalidades

### Para Administradores: 🏢
- [x]  **Nome da Funcionalidade:** Descrição.
- [x]  **Registro de Administrador:** Um administrador pode cadastrar outro usuário como administrador, informando obrigatoriamente nome, sobrenome, CPF, email e senha. O upload de uma foto é opcional.
- [x]  **Edição de conta de Administrador:** Um administrador pode editar seu nome, sobrenome e foto.

### Para Proprietários de Imóveis: 👨🏽
- [x]  **Nome da Funcionalidade:** Descrição.

### Para Inquilinos: 🗝️
- [x]  **Nome da Funcionalidade:** Descrição.


### Gems utilizadas

- [Devise](https://github.com/heartcombo/devise)
- [Rspec](https://github.com/rspec/rspec-rails)
- [Capybara](https://github.com/teamcapybara/capybara)
- [Simplecov](https://github.com/simplecov-ruby/simplecov)
- [CPF/CNPJ](https://github.com/fnando/cpf_cnpj)
- [Validators](https://github.com/fnando/validators)

## Layout da Aplicação 🖼️

Inserir aqui capturas de tela da aplicação ou gifs

### Pré-requisitos

🚨 [Ruby v3.2.2](https://www.ruby-lang.org/pt/)

🚨 [Rails v7.1.2](https://guides.rubyonrails.org/)

### Como executar a aplicação

- Clone este repositório
```
git clone https://github.com/sabinopa/rails-events
```

- Abra o diretório pelo terminal
```
cd rails-events
```

- Instale o Bundle pelo terminal
```
bundle install
```

- Crie e popule o banco de dados
```
rails db:migrate
rails db:seed
```

- Execute a aplicação
```
rails server
```

- Acesse a aplicação no link http://localhost:3000/

### Como executar os testes

Se o servidor Rails estiver rodando, será necessário pará-lo para evitar interferências durante a execução dos testes. Siga os passos detalhados abaixo:

- Interrompa o servidor Rails:

Se o servidor estiver em execução, você pode interrompê-lo pressionando `Ctrl + C` no terminal onde o servidor está ativo. Isso irá parar o processo do servidor, liberando o terminal para outras tarefas.

- Instale as dependências:

Certifique-se de que todas as dependências necessárias estão instaladas antes de iniciar os testes. Caso ainda não tenha feito isso, execute o comando:
```
bundle install
```

Este comando irá instalar todas as gems listadas no Gemfile, garantindo que nada falte para a execução dos testes.

- Execute os testes:

Com as dependências instaladas e o servidor interrompido, execute o comando abaixo para iniciar os testes:
```
rspec
```

Este comando irá rodar todos os testes definidos nos seus arquivos de teste RSpec.

- Verifique a cobertura de testes:

Após a execução dos testes, você pode verificar a cobertura de testes do projeto. A plataforma Cadê Buffet? mantém uma cobertura de 100%, e o relatório detalhado pode ser visualizado executando:
```
open coverage/index.html
```
Este comando abrirá o relatório de cobertura no seu navegador padrão, permitindo visualizar quais linhas de código foram cobertas pelos testes.

### Navegação

🧭 Para acessar páginas que requerem autenticação, utilize as contas abaixo:

|     Usuário             |   E-mail   |   Senha    |
|-------------------------|------------|------------|
|      Administrador      |    ??      |    ??      |
| Proprietário de Imóvel  |    ??      |    ??      |

### Criação de Contas Fictícias

**Testando a Plataforma:**

Para testar a plataforma PagueAluguel como administrador ou proprietário de imóvel, é necessário criar contas com CPFs ou CNPJs válidos. Recomendamos a utilização de serviços de geração de números de CPF e CNPJ válidos para garantir que a experiência de teste reflita com precisão o comportamento esperado em um cenário de uso real.

#### Recomendação de Ferramentas para Geração de CPF/CNPJ:

**Gerador de CPF/CNPJ:**

Você pode usar sites como [4Devs](https://www.4devs.com.br/) para gerar números válidos que podem ser usados para cadastro na plataforma.

## Casos de Uso

Explicar com mais detalhes como a aplicação poderia ser utilizada. O uso de **gifs** aqui seria bem interessante.

## Tarefas em aberto 📋

Listar tarefas/funcionalidades que ainda precisam ser implementadas na aplicação

▶️ Tarefa 1

▶️ Tarefa 2

▶️ Tarefa 3

## Desenvolvedores 🧑🏽‍💻🧑🏻‍💻🧑‍💻

<div align="center">
  <table>
    <tr>
      <td align="center">
        <a href="https://github.com/kanzakisuemi">
          <img src="https://avatars.githubusercontent.com/u/112991808?v=4" width="115" alt="Julia Kanzaki"/><br />
          <sub><b>Julia Kanzaki</b></sub>
        </a>
      </td>
      <td align="center">
        <a href="https://github.com/zutin">
          <img src="https://avatars.githubusercontent.com/u/119768060?v=4" width="115" alt="Gian Lucca"/><br />
          <sub><b>Gian Lucca</b></sub>
        </a>
      </td>
      <td align="center">
        <a href="https://github.com/LaiLestrange">
          <img src="https://avatars.githubusercontent.com/u/27514762?v=4" width="115" alt="Lais Almeida"/><br />
          <sub><b>Lais Almeida</b></sub>
        </a>
      </td>
      <td align="center">
        <a href="https://github.com/sabinopa">
          <img src="https://avatars.githubusercontent.com/u/142045460?v=4" width="115" alt="Priscila Sabino"/><br />
          <sub><b>Priscila Sabino</b></sub>
        </a>
      </td>
  </tr>
  <tr>
    <td align="center">
      <a href="https://github.com/NathanaelV">
        <img src="https://avatars.githubusercontent.com/u/59123681?v=4" width="115" alt="Nathanael Vieira"/><br />
        <sub><b>Nathanael Vieira</b></sub>
      </a>
    </td>
      <td align="center">
        <a href="https://github.com/mbellucio">
          <img src="https://avatars.githubusercontent.com/u/106618686?v=4" width="115" alt="Matheus Bellucio"/><br />
          <sub><b>Matheus Bellucio</b></sub>
        </a>
      </td>
      <td align="center">
        <a href="https://github.com/Arthorioscal">
          <img src="https://avatars.githubusercontent.com/u/121066943?v=4" width="115" alt="Arthur Scortegagna"/><br />
          <sub><b>Arthur Scortegagna</b></sub>
        </a>
      </td>
      <td align="center">
        <a href="https://github.com/angelomaia">
          <img src="https://avatars.githubusercontent.com/u/63835081?v=4" width="115" alt="Angelo J. Maia"/><br />
          <sub><b>Angelo J. Maia</b></sub>
        </a>
      </td>
    </tr>
  </table>
</div>

## Realizado por

Campus Code - Treinadev - T12
