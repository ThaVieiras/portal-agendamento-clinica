CREATE DATABASE clinica_agendamento;
USE clinica_agendamento; -- Garante que você está usando o banco de dados correto

-- Tabela Plano_Saude
CREATE TABLE Plano_Saude (
    id_plano_saude INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    limite_cobertura DECIMAL(10, 2), -- Exemplo: 10 dígitos no total, 2 decimais
    data_vencimento DATE
);

-- Tabela Paciente
CREATE TABLE Paciente (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    endereco VARCHAR(255),
    data_nascimento DATE,
    telefone VARCHAR(20),
    email VARCHAR(100),
    cpf VARCHAR(14) UNIQUE, -- CPF geralmente é único
    id_plano_saude INT,
    FOREIGN KEY (id_plano_saude) REFERENCES Plano_Saude(id_plano_saude) ON DELETE SET NULL -- Se o plano for excluído, o paciente fica sem plano
);

-- Tabela Medico
CREATE TABLE Medico (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    especialidade VARCHAR(100),
    crm VARCHAR(20) UNIQUE NOT NULL -- CRM deve ser único e obrigatório
);

-- Tabela Consulta
CREATE TABLE Consulta (
    id_consulta INT AUTO_INCREMENT PRIMARY KEY,
    data_hora DATETIME NOT NULL,
    valor DECIMAL(10, 2),
    status VARCHAR(50) DEFAULT 'Agendada', -- Status padrão
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente) ON DELETE CASCADE, -- Se o paciente for excluído, as consultas dele também
    FOREIGN KEY (id_medico) REFERENCES Medico(id_medico) ON DELETE CASCADE -- Se o médico for excluído, as consultas dele também
);

-- Tabela Receita
CREATE TABLE Receita (
    id_receita INT AUTO_INCREMENT PRIMARY KEY,
    descricao_medicamento TEXT NOT NULL, -- TEXT para descrições mais longas
    tempo_tratamento VARCHAR(100),
    dosagem VARCHAR(100),
    id_consulta INT UNIQUE NOT NULL, -- Uma receita para UMA consulta, e a FK garante que é uma consulta válida
    FOREIGN KEY (id_consulta) REFERENCES Consulta(id_consulta) ON DELETE CASCADE -- Se a consulta for excluída, a receita também
);

-- Tabela Pagamento
CREATE TABLE Pagamento (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    valor_pago DECIMAL(10, 2) NOT NULL,
    data_pagamento DATE NOT NULL,
    id_consulta INT UNIQUE NOT NULL, -- Um pagamento para UMA consulta
    FOREIGN KEY (id_consulta) REFERENCES Consulta(id_consulta) ON DELETE CASCADE -- Se a consulta for excluída, o pagamento também
);
USE clinica_agendamento; -- Garante que você está usando o banco de dados correto

-- Inserir Planos de Saúde
INSERT INTO Plano_Saude (nome, limite_cobertura, data_vencimento) VALUES
('Saúde Mais', 5000.00, '2025-12-31'),
('Bem Estar Total', 10000.00, '2026-06-30'),
('Plano Básico', 2000.00, '2024-11-15'); -- Plano vencido para teste da função

-- Inserir Pacientes (conectando ao Plano_Saude, um pode ser NULL)
INSERT INTO Paciente (nome, endereco, data_nascimento, telefone, email, cpf, id_plano_saude) VALUES
('João Silva', 'Rua A, 123', '1990-05-10', '11987654321', 'joao.silva@email.com', '111.111.111-11', 1), -- João tem Saúde Mais
('Maria Souza', 'Av B, 456', '1985-11-20', '21976543210', 'maria.souza@email.com', '222.222.222-22', 2), -- Maria tem Bem Estar Total
('Pedro Lima', 'Rua C, 789', '2000-01-15', '31965432109', 'pedro.lima@email.com', '333.333.333-33', NULL); -- Pedro não tem plano

-- Inserir Médicos
INSERT INTO Medico (nome, especialidade, crm) VALUES
('Dra. Ana Souza', 'Cardiologia', 'CRM/SP 123456'),
('Dr. Carlos Mendes', 'Clínica Geral', 'CRM/RJ 654321');

-- Inserir Consultas (vinculando Paciente e Medico)
INSERT INTO Consulta (data_hora, valor, status, id_paciente, id_medico) VALUES
('2025-05-10 14:00:00', 200.00, 'Realizada', 1, 1), -- Consulta do João com Dra. Ana
('2025-05-10 15:00:00', 150.00, 'Agendada', 2, 2), -- Consulta da Maria com Dr. Carlos
('2025-05-11 09:30:00', 200.00, 'Realizada', 3, 1); -- Consulta do Pedro com Dra. Ana

-- Inserir Receitas (vinculando à Consulta - apenas para consultas Realizadas, se aplicável)
INSERT INTO Receita (descricao_medicamento, tempo_tratamento, dosagem, id_consulta) VALUES
('Remédio X', '7 dias', '1 comprimido por dia', 1); -- Receita para a consulta do João

-- Inserir Pagamentos (vinculando à Consulta - apenas para consultas Realizadas e pagas)
INSERT INTO Pagamento (valor_pago, data_pagamento, id_consulta) VALUES
(200.00, '2025-05-10', 1), -- Pagamento da consulta do João
(200.00, '2025-05-11', 3); -- Pagamento da consulta do Pedro

USE clinica_agendamento; -- Garante que você está usando o banco de dados correto

-- Comando para criar a FUNCTION validar_plano_valido
-- Use DELIMITER se estiver no cliente de linha de comando ou script
DELIMITER $$

CREATE FUNCTION validar_plano_valido(
    plano_id INT,
    data_consulta DATE
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE data_vencimento_plano DATE;
    DECLARE plano_existe INT;

    -- Verifica se o plano_id existe
    SELECT COUNT(*) INTO plano_existe FROM Plano_Saude WHERE id_plano_saude = plano_id;

    IF plano_existe = 0 THEN
        -- Plano não encontrado, considerar inválido
        RETURN FALSE;
    END IF;

    -- Busca a data de vencimento do plano
    SELECT data_vencimento INTO data_vencimento_plano
    FROM Plano_Saude
    WHERE id_plano_saude = plano_id;

    -- Valida se a data da consulta é anterior ou igual à data de vencimento
    -- NULL em data_vencimento_plano é considerado válido aqui
    IF data_vencimento_plano IS NULL OR data_consulta <= data_vencimento_plano THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;

END$$

-- Restaura o DELIMITER padrão
DELIMITER ;


-- Comando para criar a VIEW relatorio_financeiro_consultas
CREATE VIEW relatorio_financeiro_consultas AS
SELECT
    c.id_consulta,
    c.data_hora,
    p.nome AS nome_paciente,
    m.nome AS nome_medico,
    pag.valor_pago
FROM
    Consulta c
JOIN
    Paciente p ON c.id_paciente = p.id_paciente
JOIN
    Medico m ON c.id_medico = m.id_medico
LEFT JOIN
    Pagamento pag ON c.id_consulta = pag.id_consulta
WHERE
    c.status = 'Realizada'; -- Filtra apenas consultas realizadas