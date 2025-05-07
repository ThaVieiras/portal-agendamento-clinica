# Portal de Agendamento para Clínica Médica

Este projeto é um protótipo inicial de um portal web para agendamento de consultas, desenvolvido como parte de um trabalho acadêmico PROJETO INTEGRADO INOVAÇÃO – DESENVOLVIMENTO WEB da Universidade Anhanguera.

**Tecnologias Utilizadas:**

* HTML, CSS, JavaScript (Front-end)
* MySQL (Banco de Dados)

**Como Configurar e Rodar:**

1.  Clone este repositório para sua máquina local.
2.  Configure o banco de dados MySQL:
    * Certifique-se de ter um servidor MySQL rodando.
    * Execute o script `sql/setup_database.sql` utilizando um cliente MySQL (Workbench, terminal, etc.). Este script irá criar o banco de dados, tabelas, inserir dados de exemplo, e criar a função/view necessárias.
3.  Abra o arquivo `frontend/index.html` no seu navegador para visualizar a página de agendamento.

**Funcionalidades Implementadas:**

* Interface básica de agendamento (seleção de data/hora, dados do paciente).
* Design responsivo para diferentes tamanhos de tela.
* Modelagem de banco de dados (MER e scripts SQL).
* Função SQL para validar validade de planos de saúde.
* View SQL para relatório financeiro consolidado.