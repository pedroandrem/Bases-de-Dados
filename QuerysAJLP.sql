-- Querys -- 

-- Ordenar Eventos por data:
SELECT NomeEvento, DataEvento, Categoria, HoraEvento,Preco,Descricao
FROM Evento
ORDER BY DataEvento;


-- Contabilizar o numero de participantes de cada evento: 
SELECT E.NomeEvento, COUNT(CE.IDCliente) as Participantes
FROM Evento E 
INNER JOIN cliente_evento CE ON E.IDEvento = CE.IDEvento
GROUP BY NomeEvento; 


-- Mostrar por cada evento o nº de participantes de cada género: 
SELECT
    E.NomeEvento,
    SUM(CASE WHEN C.Genero = 'M' THEN 1 ELSE 0 END) AS Participantes_Masculinos, SUM(CASE WHEN C.Genero = 'F' THEN 1 ELSE 0 END) AS Participantes_Femininos
FROM Evento E
JOIN Cliente_Evento CE ON E.IDEvento = CE.IDEvento
JOIN Cliente C ON CE.IDCliente = C.IDCliente
GROUP BY E.IDEvento, E.NomeEvento
ORDER BY NomeEvento; 


-- Eventos que ocorrem no segundo semestre do ano de 2024:
SELECT NomeEvento, DataEvento, Preco
FROM Evento 
Where DataEvento BETWEEN '2024-06-01' AND '2024-12-31';


-- Identificar os materiais utilizados em todos os eventos:
SELECT M.TipoDeProduto AS Nome_Material, SUM(EM.QuantidadeUtilizada) AS Utilizados
FROM Material M 
    JOIN evento_material EM on M.IDProduto = EM.IDProduto
GROUP BY Nome_Material
ORDER BY Utilizados DESC;



-- Lista o Nome, o contacto, Email e Género dos clientes cujo número de telemóvel começa por “93”:
 SELECT NomeCliente, Genero, EmailCliente, NIFCliente,Telefone
 FROM Cliente
 WHERE Telefone like '93%';
 
 -- Lista os eventos que possuem um valor acima da média por ordem decrescente de preço:
SELECT NomeEvento, Preco
FROM Evento
WHERE Preco > (SELECT AVG(Preco) FROM Evento)
ORDER BY Preco DESC; 

-- Identificar o custo de materiais associado a cada evento:
SELECT E.NomeEvento, ROUND (SUM(M.Preco * EM.QuantidadeUtilizada),2) AS CustoTotalMateriais
FROM Evento E INNER JOIN Evento_Material EM 
ON E.IDEvento = EM.IDEvento
JOIN Material M ON EM.IdProduto = M.IdProduto
GROUP BY E.IDEvento
ORDER BY 
    CustoTotalMateriais DESC;
-- Mostra os eventos com lucro líquido superior a 500€
SELECT 
    E.NomeEvento,
    COUNT(CE.IDCliente) AS Participantes,
    ROUND((E.Preco) * COUNT(CE.IDCliente), 2) AS TotalLucro,
    ROUND(((E.Preco) * COUNT(CE.IDCliente)) - (
        SELECT ROUND(SUM(M.Preco * EM.QuantidadeUtilizada), 2) AS CustoTotalMateriais
        FROM Evento_Material EM
        JOIN Material M ON EM.IdProduto = M.IdProduto
        WHERE EM.IDEvento = E.IDEvento
    ), 2) AS LucroLiquido
FROM
    Evento E
INNER JOIN Cliente_Evento CE ON E.IDEvento = CE.IDEvento
GROUP BY
    E.NomeEvento, E.Preco, E.IDEvento
HAVING
    LucroLiquido > 500 
ORDER BY
    LucroLiquido DESC;


