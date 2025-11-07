CREATE DATABASE caixa;

USE caixa;

-- =====================================================================
-- Criação das tabelas
-- =====================================================================

CREATE TABLE usuario (
    cod_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome_usuario VARCHAR(100) NOT NULL,
    username_usuario VARCHAR(100) UNIQUE NOT NULL,
    email_usuario VARCHAR(100) UNIQUE NOT NULL,
    password_usuario VARCHAR(255) NOT NULL,
    foto_usuario VARCHAR(100),  -- arquivo da imagem do usuário
    conta_ativa BOOLEAN NOT NULL DEFAULT TRUE,
    criacao_usuario TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo_usuario INT NOT NULL  -- 1 = Admin, 2 = Usuário      
);

CREATE TABLE pvp (
    cod_pvp INT AUTO_INCREMENT PRIMARY KEY,
    nome_pvp VARCHAR(100) NOT NULL,
    percentual DECIMAL(5,2) NOT NULL,
    tipo_pvp ENUM('global', 'categoria') NOT NULL,
    data_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_fim DATETIME DEFAULT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE categoria_produto (
    cod_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome_categoria VARCHAR(100) NOT NULL,
    pvp_categoria INT NOT NULL,
    descricao_categoria TEXT,
    FOREIGN KEY (pvp_categoria) REFERENCES pvp(cod_pvp)
);

CREATE TABLE unidade_medida (
    cod_unidade INT AUTO_INCREMENT PRIMARY KEY,
    nome_unidade VARCHAR(50) NOT NULL,
    sigla_unidade VARCHAR(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE venda (
    cod_venda INT AUTO_INCREMENT PRIMARY KEY,
    cod_usuario INT NOT NULL,
    data_venda TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (cod_usuario) REFERENCES usuario(cod_usuario)
);

CREATE TABLE item_venda (
    cod_item INT AUTO_INCREMENT PRIMARY KEY,
    cod_venda INT NOT NULL,
    cod_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (cod_venda) REFERENCES venda(cod_venda),
    FOREIGN KEY (cod_produto) REFERENCES produto(cod_produto)
);

CREATE TABLE caixa (
    cod_caixa INT AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('entrada', 'saida') NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    descricao TEXT,
    data_movimentacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cod_usuario INT NOT NULL,
    FOREIGN KEY (cod_usuario) REFERENCES usuario(cod_usuario)
);

-- =====================================================================
-- Inserts iniciais
-- =====================================================================

-- Unidade de Medida
INSERT INTO unidade_medida (nome_unidade, sigla_unidade) VALUES
('Quilograma','kg'),('Grama','g'),('Litro','L'),('Mililitro','mL'),('Metro','m'),
('Centímetro','cm'),('Unidade','un'),('Caixa','cx'),('Pacote','pct'),('Dúzia','dz');

-- PVP
INSERT INTO pvp (nome_pvp, percentual, tipo_pvp, ativo) VALUES
('PVP Alimentos Básicos',1.20,'categoria',TRUE),
('PVP Carnes e Aves',1.25,'categoria',TRUE),
('PVP Global Padrão',1.20,'global',TRUE);

-- Categoria Produto
INSERT INTO categoria_produto (nome_categoria, pvp_categoria, descricao_categoria) VALUES
('Alimentos Básicos',1,'Arroz, feijão, macarrão, farinha, açúcar, sal e outros itens essenciais.'),

('Carnes e Aves',2,'Carne bovina, suína, frango, peixe e derivados.');
