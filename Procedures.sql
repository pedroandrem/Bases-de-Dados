-- Procedures --


-- Dado um produto, saber em que eventos foi utilizado: 
DELIMITER $$
CREATE PROCEDURE ObterEventosPorNomeProduto
(IN produtoNome VARCHAR(30))
BEGIN
    SELECT E.NomeEvento, EM.QuantidadeUtilizada 
    FROM Material P
    JOIN Evento_Material EM ON P.IdProduto = EM.IdProduto
    JOIN Evento E ON EM.IDEvento = E.IDEvento
    WHERE P.TipoDeProduto = produtoNome
	ORDER BY EM.QuantidadeUtilizada DESC; 
END;
$$
DELIMITER 

DROP PROCEDURE IF EXISTS ObterEventosPorNomeProduto;
CALL ObterEventosPorNomeProduto('Mesa de Dj');
CALL ObterEventosPorNomeProduto('Tenda para Evento');

-- Dado um cliente, saber o preço de cada evento, considerando os descontos que o cliente possui:
DELIMITER $$
CREATE PROCEDURE CalcularPrecoTotalPorCliente(IN nome VARCHAR(100))
BEGIN
    -- Calcular o preço total considerando os descontos
    SELECT
        E.NomeEvento,
        ROUND(SUM(E.Preco * (100 - D.Percentagem) / 100),2) AS PrecoComDesconto
    FROM Evento E
    INNER JOIN Cliente_Evento CE ON E.IDEvento = CE.IDEvento
    INNER JOIN Cliente C ON CE.IDCliente = C.IDCliente
    INNER JOIN Cliente_Desconto CD ON C.IDCliente = CD.IDCliente
    INNER JOIN Desconto D ON CD.idDesc = D.idDesc
    WHERE C.NomeCliente = nome
    GROUP BY E.NomeEvento;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS CalcularPrecoTotalPorCliente ;
CALL CalcularPrecoTotalPorCliente ('Orlando Manuel Oliveira Belo');


-- Dado um mês, contabilizar o total de eventos realizados nesse mês:
DELIMITER $$

CREATE PROCEDURE ContarEventosMes(IN mesSelecionado INT)
BEGIN
    SELECT COUNT(IDEvento) AS TotalEventosNoMes
    FROM Evento
    WHERE MONTH(DataEvento) = mesSelecionado;
END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS ContarEventosMes;
CALL ContarEventosMes(1);

DELIMITER $$

-- Lucro
DELIMITER $$

CREATE PROCEDURE CalcularLucroPorEvento
(IN p_nomeEvento VARCHAR(50))
BEGIN
    SELECT 
        E.NomeEvento AS Nome_do_Evento,
        COUNT(CE.IDCliente) AS Participantes,
        ROUND((E.Preco) * COUNT(CE.IDCliente), 2) AS Valor_Total_Bilhetes,
        ROUND(((E.Preco) * COUNT(CE.IDCliente)) - (
            SELECT ROUND(SUM(M.Preco * EM.QuantidadeUtilizada), 2) AS CustoTotalMateriais
            FROM Evento_Material EM
            JOIN Material M ON EM.IdProduto = M.IdProduto
            WHERE EM.IDEvento = E.IDEvento
        ), 2) AS Lucro_Total
    FROM
        Evento E
    INNER JOIN Cliente_Evento CE ON E.IDEvento = CE.IDEvento
    WHERE
        E.NomeEvento = p_nomeEvento
    GROUP BY
        E.NomeEvento, E.Preco, E.IDEvento;
END $$

DELIMITER ;

CALL CalcularLucroPorEvento('Noite Intergaláctica de Jazz Cósmico');
CALL CalcularLucroPorEvento('Braga Cup');
CALL CalcularLucroPorEvento('Conferência de Ciência e Inovação');
CALL CalcularLucroPorEvento('Festival de Cinema ao Ar Livre');
CALL CalcularLucroPorEvento('Feira de Gastronomia Internacional');
DROP PROCEDURE IF EXISTS CalcularLucroPorEvento;



