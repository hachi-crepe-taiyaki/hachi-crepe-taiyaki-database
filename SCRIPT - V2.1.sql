DROP DATABASE hachi;
CREATE DATABASE IF NOT EXISTS hachi;
USE hachi;

CREATE TABLE usuario (
    idUsuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    telefone CHAR(11) NULL,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status_usuario TINYINT NOT NULL DEFAULT 0,
    CONSTRAINT statusUsuario
        CHECK (status_usuario = 1 OR status_usuario = 0),
	funcao TINYINT(3) NOT NULL,
    dt_nasc DATE NOT NULL,
    cidade VARCHAR(45) NOT NULL
);

CREATE TABLE categoria (
    idCategoria INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45) NOT NULL UNIQUE,
    descricao VARCHAR(255)
);

CREATE TABLE produto (
    idProduto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    preco DECIMAL(5,2) NOT NULL,
    imagem_url VARCHAR(255),
    disponivel TINYINT NOT NULL DEFAULT 1,
    fk_categoria INT NOT NULL,
		CONSTRAINT fk_produto_categoria
			FOREIGN KEY (fk_categoria) REFERENCES categoria(idCategoria)
);

CREATE TABLE compra (
    idCompra INT AUTO_INCREMENT,
    codigo CHAR(44) NOT NULL,
    valor DECIMAL(5,2) NOT NULL,
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fk_usuario INT NOT NULL,
    CONSTRAINT fk_compra_usuario
        FOREIGN KEY (fk_usuario) REFERENCES usuario(idUsuario),
	CONSTRAINT pk_compra_usuario
        PRIMARY KEY (idCompra, fk_usuario)
);

CREATE TABLE cartao_fidelidade (
    idCartao INT NOT NULL AUTO_INCREMENT,
    data_abertura DATETIME NOT NULL,
    status_cartao VARCHAR(45) NOT NULL,
    fk_usuario INT NOT NULL,

    CONSTRAINT pk_cartao_fidelidade
        PRIMARY KEY (idCartao, fk_usuario),

    CONSTRAINT fk_cartao_usuario
        FOREIGN KEY (fk_usuario)
        REFERENCES usuario(idUsuario)
);

ALTER TABLE cartao_fidelidade ADD CONSTRAINT chk_cartao_status
	CHECK (status_cartao IN ('EM_ANDAMENTO', 'CONCLUIDO', 'RESGATADO'));

CREATE TABLE carimbo (
    idCarimbo INT NOT NULL AUTO_INCREMENT,
    data_concessao DATETIME NOT NULL,
    valor_minimo DECIMAL(5,2) NOT NULL,
    fk_cartao INT NOT NULL,
    fk_compra INT NOT NULL UNIQUE,

    CONSTRAINT pk_carimbo
        PRIMARY KEY (idCarimbo, fk_cartao, fk_compra),

    CONSTRAINT fk_carimbo_cartao
        FOREIGN KEY (fk_cartao)
        REFERENCES cartao_fidelidade(idCartao),

    CONSTRAINT fk_carimbo_compra
        FOREIGN KEY (fk_compra)
        REFERENCES compra(idCompra)
);

CREATE TABLE resgate (
    idResgate INT NOT NULL AUTO_INCREMENT,
    data_resgate DATETIME NOT NULL,
    fk_cartao INT NOT NULL UNIQUE,

    CONSTRAINT pk_resgate
        PRIMARY KEY (idResgate, fk_cartao),

    CONSTRAINT fk_resgate_cartao
        FOREIGN KEY (fk_cartao)
        REFERENCES cartao_fidelidade(idCartao)
);

CREATE TABLE feedback (
	idFeedback INT AUTO_INCREMENT PRIMARY KEY,
    nota INT NOT NULL,
    comentario VARCHAR(255),
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fk_usuario INT NOT NULL,
    CONSTRAINT fk_feedback_usuario
		FOREIGN KEY (fk_usuario) REFERENCES usuario(idUsuario),
	CONSTRAINT chk_feedback_nota
        CHECK (nota BETWEEN 0 AND 5)
);

