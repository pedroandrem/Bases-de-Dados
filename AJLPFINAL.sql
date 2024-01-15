-- Criação da Base de Dados "AJLP" -- 

CREATE SCHEMA IF NOT EXISTS AJLP;
USE AJLP;

-- Apagar a base de dados
DROP SCHEMA AJLP; 

-- Criação da tabela "Empresa"
CREATE TABLE IF NOT EXISTS Empresa(
	IDEmpresa INT AUTO_INCREMENT,
	EmailEmpresa VARCHAR(50) NOT NULL ,
	Contacto INT NOT NULL ,
	NIFEmpresa INT NOT NULL ,
	NomeEmpresa VARCHAR(50) NOT NULL,
    PRIMARY KEY(IDEmpresa)
);
-- Remover a tabela "Empresa"
-- DROP TABLE Empresa;


-- Criação da tabela "Evento"
CREATE TABLE IF NOT EXISTS Evento(
    IDEvento INT AUTO_INCREMENT,
    IDEmpresa INT,
    Preco DECIMAL (4,2),
    NomeEvento VARCHAR(50) NOT NULL ,
    Descricao TEXT NOT NULL ,
    Categoria VARCHAR(30) NOT NULL ,
    HoraEvento TIME NOT NULL ,
    DataEvento date NOT NULL ,
    PRIMARY KEY(IDEvento),
    FOREIGN KEY (IDEmpresa) REFERENCES Empresa(IDEmpresa)
);
-- Remover a tabela "Evento"
-- DROP TABLE Evento;



-- Criação da tabela "Cliente"
CREATE TABLE IF NOT EXISTS Cliente(
IDCliente INT AUTO_INCREMENT,
NIFCliente INT NOT NULL ,
EmailCliente VARCHAR(50) NOT NULL ,
NomeCliente VARCHAR(50) NOT NULL ,
Telefone INT NOT NULL ,
CodigoPostal VARCHAR(8) NOT NULL ,
NumeroPorta INT NOT NULL ,
Rua VARCHAR(100) NOT NULL , 
Genero CHAR(1) NOT NULL,
PRIMARY KEY(IDCliente)
);
-- Remover a tabela "Cliente"
-- DROP TABLE Cliente;

-- Criação da tabela "Localização"
CREATE TABLE IF NOT EXISTS Localizacao(
idLocal INT AUTO_INCREMENT, 
Localizacao VARCHAR(500), 
Lotacao INT,
PRIMARY KEY(idLocal)
);
-- Remover a tabela "Localização"
-- DROP TABLE Localizacao;


-- Criação da tabela "Desconto"
CREATE TABLE IF NOT EXISTS Desconto(
idDesc INT AUTO_INCREMENT, 
Percentagem INT NOT NULL,
PRIMARY KEY(idDesc)
);
-- Remover a tabela "Desconto"
-- DROP TABLE Desconto;


-- Criação da tabela "Material"
CREATE TABLE IF NOT EXISTS Material(
IdProduto INT AUTO_INCREMENT,
Preco FLOAT NOT NULL ,
TipoDeProduto VARCHAR(30) NOT NULL,
PRIMARY KEY(IdProduto)
);
-- Remover a tabela "Material"
-- DROP TABLE Material;


-- Criação da tabela do relacionamento "Cliente - Desconto" 
CREATE TABLE IF NOT EXISTS Cliente_Desconto (
    IDCliente INT,
    idDesc INT,
    PRIMARY KEY (IDCliente, idDesc),
    FOREIGN KEY (IDCliente) REFERENCES Cliente(IDCliente),
    FOREIGN KEY (idDesc) REFERENCES Desconto(idDesc)
);
-- Remover a tabela "Cliente - Desconto"
-- DROP TABLE Cliente_Desconto;


-- Criação da tabela do relacionamento "Cliente - Evento"
CREATE TABLE IF NOT EXISTS Cliente_Evento (
    IDCliente INT,
    IDEvento INT,
    PRIMARY KEY (IDCliente, IDEvento),
    FOREIGN KEY (IDCliente) REFERENCES Cliente(IDCliente),
    FOREIGN KEY (IDEvento) REFERENCES Evento(IDEvento)
);
-- Remover a tabela "Empresa"
-- DROP TABLE Cliente_Evento;


-- Criação da tabela do relacionamento "Evento - Localização"
CREATE TABLE IF NOT EXISTS Evento_Localizacao (
    IDEvento INT,
    idLocal INT,
    PRIMARY KEY (IDEvento, idLocal),
    FOREIGN KEY (IDEvento) REFERENCES Evento(IDEvento),
    FOREIGN KEY (idLocal) REFERENCES Localizacao(idLocal)
);
-- Remover a tabela "Evento - Localização"
-- DROP TABLE Evento_Localizacao;


-- Criação da tabela do relacionamento "Evento - Material"
CREATE TABLE IF NOT EXISTS Evento_Material (
    IDEvento INT,
    IdProduto INT,
    QuantidadeUtilizada INT,
    PRIMARY KEY (IDEvento, IdProduto),
    FOREIGN KEY (IDEvento) REFERENCES Evento(IDEvento),
    FOREIGN KEY (IdProduto) REFERENCES Material(IdProduto)
);
-- Remover a tabela "Evento - Material"
-- DROP TABLE Evento_Material;


-- Tabelas de caractetização:
DESC Empresa;
DESC Evento;
DESC Cliente;
DESC Localização;
DESC Desconto;
DESC Material;
DESC Cliente_Desconto;
DESC Cliente_Evento;
DESC Evento_Localizacao;
DESC Evento_Material;



-- Vista de Detalhes do Evento:
CREATE VIEW DetalhesEvento AS
SELECT
    E.IDEvento,
    E.NomeEvento,
    E.Descricao,
    E.Categoria,
    E.HoraEvento,
    E.DataEvento,
    EM.IdProduto,
    EM.QuantidadeUtilizada,
    L.Localizacao,
    L.Lotacao
FROM Evento E
INNER JOIN Evento_Material EM ON E.IDEvento = EM.IDEvento 
INNER JOIN Evento_Localizacao EL ON E.IDEvento = EL.IDEvento
INNER JOIN Localizacao L ON EL.idLocal = L.idLocal;

SELECT * FROM DetalhesEvento;

-- Vista de Clientes participantes de Eventos:
CREATE VIEW ClientesParticipantes AS
SELECT
	C.NomeCliente,
    C.NIFCliente,
    C.EmailCliente,
    C.Telefone,
    E.NomeEvento
FROM Cliente C
JOIN Cliente_Evento CE ON C.IDCliente = CE.IDCliente
JOIN Evento E ON CE.IDEvento = E.IDEvento;

SELECT * FROM ClientesParticipantes; 

-- Vista dos TOP3 eventos com mais participantes 

CREATE VIEW TOP3 AS 
SELECT E.NomeEvento, COUNT(CE.IDCliente) AS Nr_Clientes 
FROM Evento E 
INNER JOIN cliente_evento CE ON E.IDevento = CE.IDevento
GROUP BY E.NomeEvento
ORDER BY Nr_Clientes DESC 
LIMIT 3; 

-- DROP VIEW TOP3; 
SELECT * FROM TOP3; 


-- INDEX 
-- Usamos para os materiais e eventos
CREATE INDEX NomeEvento ON Evento (NomeEvento);
CREATE INDEX Materiais ON Material (TipoDeProduto);

-- Criar o usuário 'usuario' associado ao host 'localhost' e definir a senha
CREATE USER 'usuario'@'localhost' IDENTIFIED BY 'senha';

-- Conceder permissões específicas para o usuário 'usuario' na base de dados 'AJLP'
GRANT SELECT, INSERT, UPDATE, DELETE ON ajlp.* TO 'usuario'@'localhost';