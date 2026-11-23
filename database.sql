DROP DATABASE IF EXISTS nado_livre;

CREATE DATABASE nado_livre
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE nado_livre;


CREATE TABLE nadador (
    id_nadador INT PRIMARY KEY AUTO_INCREMENT,
    nome       VARCHAR(100) NOT NULL
);

CREATE TABLE toalha (
    id_toalha INT PRIMARY KEY AUTO_INCREMENT,
    status    VARCHAR(20) NOT NULL DEFAULT 'disponivel',

    CONSTRAINT ck_toalha_status
        CHECK (status IN ('disponivel', 'em_uso', 'manutencao'))
);

CREATE TABLE atendente (
    id_atendente INT PRIMARY KEY AUTO_INCREMENT,
    nome         VARCHAR(100) NOT NULL
);

CREATE TABLE utilizacao (
    id_utilizacao          INT PRIMARY KEY AUTO_INCREMENT,
    data_hora_retirada     DATETIME NOT NULL,
    data_hora_devolucao    DATETIME NULL,
    status                 VARCHAR(20) NOT NULL DEFAULT 'em_uso',
    id_nadador             INT NOT NULL,
    id_toalha              INT NOT NULL,
    id_atendente_entrega   INT NOT NULL,
    id_atendente_devolucao INT NULL,

    CONSTRAINT fk_utilizacao_nadador
        FOREIGN KEY (id_nadador)
        REFERENCES nadador (id_nadador)
        ON DELETE RESTRICT,

    CONSTRAINT fk_utilizacao_toalha
        FOREIGN KEY (id_toalha)
        REFERENCES toalha (id_toalha)
        ON DELETE RESTRICT,

    CONSTRAINT fk_utilizacao_atendente_entrega
        FOREIGN KEY (id_atendente_entrega)
        REFERENCES atendente (id_atendente)
        ON DELETE RESTRICT,

    CONSTRAINT fk_utilizacao_atendente_devolucao
        FOREIGN KEY (id_atendente_devolucao)
        REFERENCES atendente (id_atendente)
        ON DELETE RESTRICT,

    CONSTRAINT ck_utilizacao_status
        CHECK (status IN ('em_uso', 'devolvida')),

    -- devolução não pode ser anterior à retirada
    CONSTRAINT ck_utilizacao_datas
        CHECK (data_hora_devolucao IS NULL
               OR data_hora_devolucao >= data_hora_retirada),

    -- empréstimo aberto: sem data e sem atendente de devolução;
    -- empréstimo encerrado: com data e com atendente de devolução
    CONSTRAINT ck_utilizacao_coerencia
        CHECK (
            (status = 'em_uso'
                AND data_hora_devolucao IS NULL
                AND id_atendente_devolucao IS NULL)
            OR
            (status = 'devolvida'
                AND data_hora_devolucao IS NOT NULL
                AND id_atendente_devolucao IS NOT NULL)
        ),

    -- impede empréstimos duplicados: cada toalha só pode ter
    -- UMA utilização em aberto (devolução NULL) por vez
    CONSTRAINT uq_toalha_em_aberto
        UNIQUE ((CASE WHEN data_hora_devolucao IS NULL THEN id_toalha END)),

    INDEX idx_utilizacao_data_retirada (data_hora_retirada),
    INDEX idx_utilizacao_status_data (status, data_hora_retirada),
    INDEX idx_utilizacao_nadador_data (id_nadador, data_hora_retirada)
);


INSERT INTO nadador (id_nadador, nome) VALUES
    (1, 'Henrique Nascimento Barbosa'),
    (2, 'Otávio Cardoso Campos'),
    (3, 'Gabriela Nunes Costa'),
    (4, 'Yasmin Moreira Rocha'),
    (5, 'Heitor Melo Dias'),
    (6, 'Sofia Pinto Monteiro'),