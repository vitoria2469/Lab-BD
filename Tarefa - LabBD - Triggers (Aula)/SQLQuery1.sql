CREATE TABLE times (
    cod_time INT PRIMARY KEY,
    nome_time VARCHAR(50)
)
GO
CREATE TABLE jogos (
    cod_time_a INT,
    cod_time_b INT,
    set_time_a INT,
    set_time_b INT,
    FOREIGN KEY (cod_time_a) REFERENCES times(cod_time),
    FOREIGN KEY (cod_time_b) REFERENCES times(cod_time)
)

---------------------------------------------------------

CREATE FUNCTION calcular_estatisticas()
RETURNS TABLE (
    nome_time VARCHAR(50),
    total_pontos INT,
    total_sets_ganhos INT,
    total_sets_perdidos INT,
    set_average INT
)
AS
BEGIN
    RETURN (
        SELECT 
            t.nome_time,
            SUM(CASE 
                WHEN (j.set_time_a > j.set_time_b AND j.cod_time_a = t.cod_time) THEN 
                    CASE 
                        WHEN j.set_time_a = 3 THEN 3 
                        ELSE 2 
                    END
                WHEN (j.set_time_b > j.set_time_a AND j.cod_time_b = t.cod_time) THEN 
                    CASE 
                        WHEN j.set_time_b = 3 THEN 0 
                        ELSE 1 
                    END
                ELSE 0 
            END) AS total_pontos,
            SUM(CASE 
                WHEN j.cod_time_a = t.cod_time THEN j.set_time_a 
                WHEN j.cod_time_b = t.cod_time THEN j.set_time_b 
                ELSE 0 
            END) AS total_sets_ganhos,
            SUM(CASE 
                WHEN j.cod_time_a = t.cod_time THEN j.set_time_b 
                WHEN j.cod_time_b = t.cod_time THEN j.set_time_a 
                ELSE 0 
            END) AS total_sets_perdidos,
            (SUM(CASE 
                WHEN j.cod_time_a = t.cod_time THEN j.set_time_a 
                WHEN j.cod_time_b = t.cod_time THEN j.set_time_b 
                ELSE 0 
            END) - SUM(CASE 
                WHEN j.cod_time_a = t.cod_time THEN j.set_time_b 
                WHEN j.cod_time_b = t.cod_time THEN j.set_time_a 
                ELSE 0 
            END)) AS set_average
        FROM 
            times t
        LEFT JOIN 
            jogos j ON j.cod_time_a = t.cod_time OR j.cod_time_b = t.cod_time
        GROUP BY 
            t.nome_time
    )
END

----------------------------------

CREATE TRIGGER verificar_jogos
BEFORE INSERT ON jogos
FOR EACH ROW
BEGIN
    DECLARE total_sets INT;
    
    -- Verifica se o total de sets é maior que 5
    SET total_sets = NEW.set_time_a + NEW.set_time_b;
    IF total_sets > 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O total de sets não pode ser maior que 5.';
    END IF;

    -- Verifica se o time vencedor tem no máximo 3 sets
    IF NEW.set_time_a > NEW.set_time_b AND NEW.set_time_a > 3 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O time vencedor não pode ter mais de 3 sets.';
    END IF;

    IF NEW.set_time_b > NEW.set_time_a AND NEW.set_time_b > 3 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O time vencedor não pode ter mais de 3 sets.';
    END IF
END