# PagueAluguel - Sistema de Cobrança de Aluguéis e Taxas de Condomínio

![Static Badge](https://img.shields.io/badge/Ruby_3.2.2-CC342D?style=for-the-badge&logo=ruby&logoColor=white)
![Static Badge](https://img.shields.io/badge/Ruby_on_Rails_7.1.3.1-CC0000?style=for-the-badge&logo=ruby-on-rails&logoColor=white)
![Bootstrap](https://img.shields.io/badge/bootstrap-%238511FA.svg?style=for-the-badge&logo=bootstrap&logoColor=white)

![Static Badge](https://img.shields.io/badge/COBERTURA_DE_TESTES-97%25-blue)
![Static Badge](https://img.shields.io/badge/STATUS-EM_DESENVOLVIMENTO-green)

### Tópicos

▶️ [Descrição do projeto](#descrição-do-projeto)

▶️ [Funcionalidades](#funcionalidades)

▶️ [Gems utilizadas](#gems-utilizadas)

▶️ [Layout da aplicação](#layout-da-aplicacao)

▶️ [Pré-requisitos](#pré-requisitos)

▶️ [Como executar a aplicação](#como-executar-a-aplicação)

▶️ [Integração com o CondoMinions](#integracao-com-condominions)

▶️ [Como executar os testes](#como-executar-os-testes)

▶️ [Navegação](#navegação)

▶️ [Criação de Contas Fictícias](#criação-de-contas-fictícias)

▶️ [Desenvolvedores](#desenvolvedores)

## Descrição do Projeto

📍 PagueAluguel é uma aplicação para o envio de cobranças de aluguel, taxas de condomínio e outras cobranças relacionadas aos imóveis de um condomínio. O sistema é utilizado por usuários proprietários de apartamentos do condomínio e usuários com perfil administrativo. A aplicação está integrada com a aplicação [CondoMinions](https://github.com/TreinaDev/condominions) para fazer a validação de dados de unidades e para garantir que os moradores recebam as cobranças mensais de suas unidades.

## Funcionalidades

### Registro de Usuários

- [x] **Cadastro de Administradores:** Super Admins podem cadastrar novos administradores com nome completo, CPF, e-mail, foto e senha, mas com acessos limitados conforme definidos pelo Super Admin.
- [x] **Cadastro de Proprietários:** Proprietários podem se registrar na plataforma com validação do CPF pela aplicação CondoMinions.
- [x] **Gestão de Múltiplos Imóveis:** Um usuário pode ser registrado como proprietário de múltiplos imóveis, com integração da App CondoMinions.

### Gestão de Taxas Condominiais

- [x] **Cadastro de Taxas:** Administradores podem cadastrar taxas condominiais fixas, com nome, valor, recorrência (quinzenal, mensal, bimestral, semestral, anual) e dia de lançamento.
- [x] **Juros e Multa:** Opção para adicionar juros e multa por atraso nas taxas.

### Rateio de Contas Compartilhadas

- [x] **Lançamento de Contas:** Administradores podem lançar contas de serviços compartilhados (água, energia, etc.), com descrição, data e valor total.
- [x] **Distribuição Automática:** O valor é distribuído automaticamente entre unidades conforme fração ideal cadastrada em CondoMinions.

### Taxas de Uso de Áreas Comuns

- [x] **Cadastro de Taxas de Uso:** Administradores podem cadastrar taxas de utilização padrão para áreas comuns.
- [x] **Modificação e Histórico:** Taxas de uso podem ser modificadas, mantendo o histórico de valores.

### Registro e Gerenciamento de Cobranças Avulsas

- [x] **Registro de Cobranças Avulsas:** Administradores e proprietários podem registrar cobranças avulsas com unidade, valor, data de lançamento e descrição.
- [ ] **Integração com CondoMinions:** Reservas de áreas comuns na aplicação CondoMinions geram automaticamente cobranças avulsas.

### Cobrança de Aluguel

- [ ] **Configuração de Aluguel:** Proprietários podem configurar a cobrança de aluguel, com valor, dia de lançamento, juros e multa por atraso.
- [ ] **Desativação de Cobrança:** Proprietários podem desativar a cobrança de aluguel automaticamente se o imóvel deixar de ser alugado.

### Emissão de Boletos de Condomínio

- [x] **Geração de Boletos:** Todo dia 01 de cada mês, são gerados boletos contendo todas as cobranças da unidade.
- [ ] **Detalhamento de Boletos:** Boletos contêm itens cobrados e registram pagador e recebedor com dados do CondoMinions.

### Acesso a Boletos

- [ ] **Visualização de Boletos:** Inquilinos podem visualizar boletos de pagamento sem necessidade de login, informando apenas o CPF.
- [ ] **Validação de CPF:** A aplicação valida o CPF com o CondoMinions para acesso aos boletos.

### Registro de Pagamento

- [ ] **Gestão de Pagamentos:** Administradores podem visualizar, filtrar e confirmar pagamentos de boletos, registrando data de pagamento e código da transação.

### Emissão de Certidão Negativa de Débitos

- [ ] **Emissão de Certidão:** Administradores, proprietários e moradores (sem autenticação) podem emitir certidões negativas de débito se não houver boletos vencidos e não pagos.
- [ ] **Validação e Geração:** Certidão é gerada no momento da solicitação com data e hora da emissão.


## Gems utilizadas

- [Rspec](https://github.com/rspec/rspec-rails): Framework de testes para Ruby on Rails.
- [Capybara](https://github.com/teamcapybara/capybara): Ferramenta de testes para simular navegação do usuário.
- [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers): Matchers para facilitar a escrita de testes em Rails.
- [Factory Bot Rails](https://github.com/thoughtbot/factory_bot): Biblioteca para criar dados de teste.
- [Simplecov](https://github.com/simplecov-ruby/simplecov): Ferramenta de cobertura de código para Ruby.
- [Devise](https://github.com/heartcombo/devise): Gem para autenticação de usuários.
- [CPF/CNPJ](https://github.com/fnando/cpf_cnpj): Biblioteca para validação e formatação de CPF e CNPJ.
- [Faraday](https://github.com/lostisland/faraday): Biblioteca para requisições HTTP.
- [Money Rails](https://github.com/RubyMoney/money-rails): Extensão para gerenciamento de valores monetários em Rails.
- [Stimulus-Rails](https://stimulus.hotwired.dev/): Integração do Stimulus com Rails.
- [Whenever](https://github.com/javan/whenever): Gem para agendamento de tarefas cron.

## Layout da Aplicação 🖼️

<p style="color:red;">Inserir aqui capturas de tela da aplicação ou gifs</p>

## Pré-requisitos

🚨 [Ruby v3.2.2](https://www.ruby-lang.org/pt/)

🚨 [Rails v7.1.3.1](https://guides.rubyonrails.org/)

## Como executar a aplicação

- Clone este repositório
```
git clone git@github.com:TreinaDev/pague-aluguel.git
```

- Abra o diretório pelo terminal
```
cd pague-aluguel
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
bin/dev -p 4000
```

- Acesse a aplicação no link http://localhost:4000/

## Integração com o CondoMinions

Para ver a aplicação funcionando por completo com as APIs integradas, você também precisará clonar e executar o projeto CondoMinions. Siga os passos abaixo para configurar e executar o CondoMinions:

- Clone o repositório CondoMinions
```
git clone git@github.com:TreinaDev/condominions.git
```

- Abra o diretório CondoMinions pelo terminal
```
cd condominions
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

- Execute a aplicação CondoMinions
```
bin/dev
```

- Acesse a aplicação no link: http://localhost:3000/

**Visualização Completa:** Com ambas as aplicações rodando, você poderá ver o PagueAluguel funcionando plenamente, incluindo todas as funcionalidades dependentes da integração com o CondoMinions.

## Como executar os testes

- Execute os testes:

```
rake spec
```

Este comando irá rodar todos os testes definidos nos seus arquivos de teste RSpec.

- Verifique a cobertura de testes:

Após a execução dos testes, você pode verificar a cobertura de testes do projeto. O relatório detalhado pode ser visualizado executando:
```
open coverage/index.html
```
Este comando abrirá o relatório de cobertura no seu navegador padrão, permitindo visualizar quais linhas de código foram cobertas pelos testes.

## Navegação

🧭 Para acessar páginas que requerem autenticação, utilize as contas abaixo:

|     Usuário             |     E-mail   |   Senha    |
|-------------------------|------------|------------|
|   Super Administrador   |  kanzaki@myself.com  |    password123    |
|      Administrador      |   matheus@mail.com    |    123456     |
| Proprietário de Imóvel  |    lais@email.com      |    lais123     |

### Criação de Contas Fictícias

**Testando a Plataforma:**

Para testar a plataforma PagueAluguel como administrador ou proprietário de imóvel, é necessário criar contas com CPFs ou CNPJs válidos. Recomendamos a utilização de serviços de geração de números de CPF e CNPJ válidos para garantir que a experiência de teste reflita com precisão o comportamento esperado em um cenário de uso real.

#### Recomendação de Ferramentas para Geração de CPF/CNPJ:

**Gerador de CPF/CNPJ:**

Você pode usar sites como [4Devs](https://www.4devs.com.br/) para gerar números válidos que podem ser usados para cadastro na plataforma.

# APIs

### 1. Taxas de Áreas Comuns

`GET /api/v1/condos/:id/common_area_fees`

Recebe como parâmetro `:id` de um condomínio, e retorna uma lista com **a última taxa cadastrada para cada área comum desse condomínio**
Retorna:
Caso o condomínio não possua nenhuma taxa cadastrada: `status: 200, json: []`
Caso o condomínio possua alguma taxa cadastrada: `status: 200, json:`
```
[
  {
    "id":1,
    "value_cents":20000,
    "created_at":"2024-07-11T21:09:13.019Z",
    "common_area_id":1,
    "condo_id":1,
  },
  {
    "id":2,
    "value_cents":30000,
    "created_at":"2024-07-11T21:09:13.024Z",
    "common_area_id":2,
    "condo_id":1
  },
  {
    "id":3,
    "value_cents":40000,
    "created_at":"2024-07-11T21:09:13.027Z",
    "common_area_id":3,
    "condo_id":1
  }
]
```

`GET /api/v1/common_area_fees/:id`

Recebe como parâmetro o `:id` de uma taxa cadastrada e retorna **os detalhes da taxa de área comum** desejada
Retorna:
Caso não exista taxa com o id informado: `status: 404, json: { "errors":"Não encontrado" } `
Caso o condomínio possua alguma taxa cadastrada: `status: 200, json:`
```
{
  "value_cents":20000,
  "created_at":"2024-07-11T21:09:13.019Z",
  "common_area_id":1,
  "condo_id":1
}
```

### 2. Cobranças Avulsas

`POST /api/v1/single_charges/?params`

Expõe uma API endpoint de criação de model `single_charge`, válido para criação de Multas e Reservas de Áreas Comuns.

Resposta para criação com sucesso: `status: 201` (:created)

Resposta para falha na criação: `status: 422` (:unprocessable_entity)

- São obrigatórios: `unit_id`, `condo_id`, `value_cents`, `issue_date`, `charge_type`
- `issue_date` não pode estar no passado
- se o `charge_type == common_area_fee`, a `common_area_id` é obrigatória
- se o `charge_type == fine`, a `description` é obrigatória
- a `unit_id` deve pertencer ao `condo_id` (unidade deve ser do condomínio)

Recebe os seguintes parâmetros:
```
{ single_charge: {
                  description: string,
                  value_cents: integer,
                  charge_type: enum (:fine ou :common_area_fee),
                  issue_date: date,
                  condo_id: integer,
                  common_area_id: integer,
                  unit_id: integer
                  }
}
```

Exemplo de cobrança avulsa (Multa):
```
{ single_charge: {
                  description: 'Multa por barulho durante a madrugada',
                  value_cents: 10000,
                  charge_type: :fine,
                  issue_date: 5.days.from_now.to_date,
                  condo_id: 1,
                  common_area_id: nil,
                  unit_id: 1
                  }
}
```

Exemplo de cobrança avulsa (Reserva de Área Comum):
```
{ single_charge: {
                  description: nil,
                  value_cents: ~deve retornar do endpoint de taxas de áreas comuns~,
                  charge_type: :common_area_fee,
                  issue_date: 5.days.from_now.to_date,
                  condo_id: 1,
                  common_area_id: 2,
                  unit_id: 1
                  }
}
```

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
