CREATE DATABASE AULA02

USE Aula02

CREATE TABLE Motorista(
	Codigo INT NOT NULL,
	Nome VARCHAR(100),
	Naturalidade VARCHAR(50),
	PRIMARY KEY (Codigo)
)

CREATE TABLE Onibus(
	Placa VARCHAR(7),
	Marca VARCHAR(10),
	Ano INT NOT NULL,
	Descricao VARCHAR(100),
	PRIMARY KEY (Placa)
)

CREATE TABLE Viagem(
	Codigo INT NOT NULL,
	Onibus VARCHAR(7),
	Motorista INT NOT NULL,
	HoraDeSaida INT NOT NULL CHECK (horaDeSaida >= 0),
	HoraDeChegada INT NOT NULL CHECK (horaDeChegada >= 0),
	Partida VARCHAR(50),
	Destino VARCHAR(50),
	PRIMARY KEY (Codigo),
	FOREIGN KEY (Motorista) REFERENCES Motorista(Codigo),
	FOREIGN KEY (Onibus) REFERENCES Onibus(Placa),
)
GO
SELECT * FROM Viagem
SELECT * FROM Motorista
SELECT * FROM Onibus

--Exerc�cio:
--1) Criar um Union das tabelas Motorista e �nibus, com as colunas ID (C�digo e Placa) e Nome (Nome e Marca)
SELECT  CAST(Codigo AS VARCHAR (6)) AS ID, Nome AS Nome
FROM Motorista
UNION
SELECT Placa AS ID, Marca AS Nome
FROM Onibus

--2) Criar uma View (Chamada v_motorista_onibus) do Union acima
CREATE VIEW v_motorista_onibus AS
SELECT  CAST(Codigo AS VARCHAR (6)) AS ID, Nome AS Nome
FROM Motorista
UNION
SELECT Placa AS ID, Marca AS Nome
FROM Onibus

SELECT * FROM v_motorista_onibus

--3) Criar uma View (Chamada v_descricao_onibus) que mostre o C�digo da Viagem, 
--o Nome do motorista, a placa do �nibus (Formato XXX-0000), a Marca do �nibus, o Ano do �nibus e a descri��o do onibus
CREATE VIEW v_descricao_onibus AS
SELECT Viagem.Codigo, Motorista.Nome, SUBSTRING(Placa, 1, 3) + '-' + SUBSTRING(Placa, 4, 7) AS Placa, Ano, Descricao
FROM Viagem INNER JOIN Motorista ON Motorista = Motorista.Codigo INNER JOIN Onibus ON Placa = Onibus
ORDER BY Viagem.Codigo ASC

SELECT * FROM v_descricao_onibus

--4) Criar uma View (Chamada v_descricao_viagem) que mostre o C�digo da viagem, a placa do �nibus(Formato XXX-0000), 
--a Hora da Sa�da da viagem (Formato HH:00), a Hora da Chegada da viagem (Formato HH:00), partida e destino
CREATE VIEW v_descricao_viagem AS
SELECT Viagem.codigo, SUBSTRING(Placa, 1, 3) + '-' + SUBSTRING(Placa, 4, 7) AS Placa,
	CASE WHEN (HoraDeSaida < 10) THEN
		'0' + CAST(HoraDeSaida AS VARCHAR(2)) + ':00'
	ELSE 
		CAST(HoraDeSaida AS VARCHAR(2)) + ':00'
	END AS HoraDeSaida,
	CASE WHEN (HoraDeChegada < 10) THEN
		'0' + CAST(HoraDeChegada AS VARCHAR(2)) + ':00'
	ELSE
		CAST(HoraDeChegada AS VARCHAR(2)) + ':00'
	END AS HoraDeChegada,
	Partida,
	Destino
FROM Viagem INNER JOIN Onibus ON Onibus = Placa
ORDER BY Codigo ASC

SELECT * FROM v_descricao_viagem