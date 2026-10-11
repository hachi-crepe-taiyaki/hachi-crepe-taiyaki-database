DROP DATABASE hachi;
CREATE DATABASE IF NOT EXISTS hachi;
USE hachi;

CREATE TABLE usuario (
    idUsuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(20) NOT NULL,
    telefone CHAR(11) NULL,
    pontos INT NOT NULL DEFAULT 0,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `status` TINYINT NOT NULL DEFAULT 0,
    CONSTRAINT statusUsuario
        CHECK (`status` = 1 OR `status`= 0),
	funcao TINYINT(3) NOT NULL,
    dt_nasc DATE NOT NULL,
    cidade VARCHAR(45) NOT NULL
);

CREATE TABLE brinde (
    idBrinde INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45) NOT NULL,
    descricao VARCHAR(255)
);

CREATE TABLE categoria (
    idCategoria INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45) NOT NULL,
    descricao VARCHAR(255)
);

CREATE TABLE beneficio (
    idBeneficio INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    custo INT NOT NULL,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fk_brinde INT,
		CONSTRAINT fk_beneficio_brinde
			FOREIGN KEY (fk_brinde)	REFERENCES brinde(idBrinde)
);

CREATE TABLE produto (
    idProduto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    preco DECIMAL(5,2) NOT NULL,
    imagem_url VARCHAR(255),
    disponivel TINYINT NOT NULL DEFAULT 1,
    categoria_idCategoria INT NOT NULL,
		CONSTRAINT fk_produto_categoria
			FOREIGN KEY (categoria_idCategoria)	REFERENCES categoria(idCategoria)
);

CREATE TABLE compra (
    idCompra INT AUTO_INCREMENT PRIMARY KEY,
    codigo CHAR(44) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fk_usuario INT NOT NULL,
    CONSTRAINT fk_compra_usuario
        FOREIGN KEY (fk_usuario) REFERENCES usuario(idUsuario)
);

CREATE TABLE resgate (
    idResgate INT NOT NULL,
    custo INT NOT NULL,
    data_resgate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fk_usuario INT NOT NULL,
    fk_beneficio INT NOT NULL,
    CONSTRAINT pk_resgate
        PRIMARY KEY (idResgate, fk_usuario, fk_beneficio),
    CONSTRAINT fk_resgate_usuario
        FOREIGN KEY (fk_usuario) REFERENCES usuario(idUsuario),
    CONSTRAINT fk_resgate_beneficio
        FOREIGN KEY (fk_beneficio) REFERENCES beneficio(idBeneficio)
);

CREATE TABLE item_compra (
    idItem INT AUTO_INCREMENT PRIMARY KEY,
    fk_compra INT NOT NULL,
    fk_produto INT NOT NULL,
    quantidade INT NOT NULL,
    CONSTRAINT fk_item_compra_compra
        FOREIGN KEY (fk_compra) REFERENCES compra(idCompra),
	CONSTRAINT fk_item_compra_produto
        FOREIGN KEY (fk_produto) REFERENCES produto(idProduto),
    CONSTRAINT chk_item_quantidade
        CHECK (quantidade > 0)
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
        CHECK (nota BETWEEN 1 AND 5)
);

CREATE TABLE solicitacao_musica (
	idSolicitacao INT AUTO_INCREMENT PRIMARY KEY,
    musica VARCHAR(255) NOT NULL,
    artista VARCHAR(255) NOT NULL,
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fk_usuario INT NOT NULL,
    CONSTRAINT fk_musica_usuario
		FOREIGN KEY (fk_usuario) REFERENCES usuario(idUsuario)
);
