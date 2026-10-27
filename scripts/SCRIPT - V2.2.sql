-- ==============================================================================
-- Hachi Crepe e Taiyaki - Script DDL Banco de Dados (Versão 2.2)
-- Equipe H8 - Projeto de Extensão Universitário (SPTech)
-- ==============================================================================

CREATE DATABASE IF NOT EXISTS `hachi` 
  DEFAULT CHARACTER SET utf8mb4 
  COLLATE utf8mb4_unicode_ci;

USE `hachi`;

-- ------------------------------------------------------------------------------
-- Tabela: categoria
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `categoria` (
  `idCategoria` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `descricao` VARCHAR(255) NULL,
  PRIMARY KEY (`idCategoria`),
  UNIQUE INDEX `uk_categoria_nome` (`nome` ASC)
) ENGINE = InnoDB;

-- ------------------------------------------------------------------------------
-- Tabela: produto
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `produto` (
  `idProduto` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `descricao` VARCHAR(255) NULL,
  `preco` DECIMAL(5,2) NOT NULL,
  `imagem_url` VARCHAR(255) NULL,
  `disponivel` TINYINT NOT NULL DEFAULT 1,
  `fk_categoria` INT NOT NULL,
  PRIMARY KEY (`idProduto`),
  INDEX `idx_produto_categoria` (`fk_categoria` ASC),
  CONSTRAINT `fk_produto_categoria`
    FOREIGN KEY (`fk_categoria`)
    REFERENCES `categoria` (`idCategoria`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- ------------------------------------------------------------------------------
-- Tabela: usuario
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `usuario` (
  `idUsuario` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `senha` VARCHAR(255) NOT NULL,
  `telefone` CHAR(11) NULL,
  `criado_em` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status_usuario` TINYINT NOT NULL DEFAULT 1,
  `funcao` TINYINT(3) NOT NULL DEFAULT 0,
  `dt_nasc` DATE NULL,
  `cidade` VARCHAR(100) NULL,
  `regiao` VARCHAR(100) NULL,
  `selos` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`idUsuario`),
  UNIQUE INDEX `uk_usuario_email` (`email` ASC)
) ENGINE = InnoDB;

-- ------------------------------------------------------------------------------
-- Tabela: Codigo
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Codigo` (
  `idCodigos` INT NOT NULL AUTO_INCREMENT,
  `codigo` CHAR(6) NOT NULL,
  `statusScan` TINYINT NOT NULL DEFAULT 0,
  `valor` DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (`idCodigos`),
  UNIQUE INDEX `uk_codigo` (`codigo` ASC)
) ENGINE = InnoDB;

-- ------------------------------------------------------------------------------
-- Tabela: resgate_selo
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `resgate_selo` (
  `idResgate` INT NOT NULL AUTO_INCREMENT,
  `Codigos_idCodigos` INT NOT NULL,
  `usuario_idUsuario` INT NOT NULL,
  `data_hora` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idResgate`),
  UNIQUE INDEX `uk_resgate_codigo` (`Codigos_idCodigos` ASC),
  INDEX `idx_resgate_selo_usuario` (`usuario_idUsuario` ASC),
  CONSTRAINT `fk_resgate_selo_codigo`
    FOREIGN KEY (`Codigos_idCodigos`)
    REFERENCES `Codigo` (`idCodigos`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_resgate_selo_usuario`
    FOREIGN KEY (`usuario_idUsuario`)
    REFERENCES `usuario` (`idUsuario`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- ------------------------------------------------------------------------------
-- Tabela: resgate_item
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `resgate_item` (
  `idResgate` INT NOT NULL AUTO_INCREMENT,
  `data_resgate` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_idUsuario` INT NOT NULL,
  PRIMARY KEY (`idResgate`),
  INDEX `idx_resgate_item_usuario` (`usuario_idUsuario` ASC),
  CONSTRAINT `fk_resgate_item_usuario`
    FOREIGN KEY (`usuario_idUsuario`)
    REFERENCES `usuario` (`idUsuario`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- ------------------------------------------------------------------------------
-- Tabela: feedback
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `feedback` (
  `idFeedback` INT NOT NULL AUTO_INCREMENT,
  `nota` INT NOT NULL,
  `comentario` VARCHAR(255) NULL,
  `data_hora` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fk_usuario` INT NOT NULL,
  PRIMARY KEY (`idFeedback`),
  INDEX `idx_feedback_usuario` (`fk_usuario` ASC),
  CONSTRAINT `fk_feedback_usuario`
    FOREIGN KEY (`fk_usuario`)
    REFERENCES `usuario` (`idUsuario`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `chk_feedback_nota`
    CHECK (`nota` BETWEEN 0 AND 5)
) ENGINE = InnoDB;
