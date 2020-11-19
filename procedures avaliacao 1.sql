delimiter $$
CREATE PROCEDURE inserir_professor(IN nome_entr VARCHAR (255),
									IN nascimento_entr DATE,
                                    IN telefone_fixo_entr VARCHAR (20),
                                    IN telefone_celular_entr VARCHAR (20),
                                    IN endereco_entr VARCHAR (200),
                                    IN salario_entr DECIMAL)
BEGIN
	INSERT INTO pessoa (nome, nascimento, telefone_fixo, telefone_celular, endereco)
    VALUES (nome_entr, nascimento_entr, telefone_fixo_entr, telefone_celular_entr, endereco_entr);
    SET @pessoa = last_insert_id();
    INSERT INTO professor (salario, pessoa)
    VALUES (salario_entr, @pessoa);
END $$
delimiter;

delimiter $$
CREATE PROCEDURE atualizar_professor(IN id_professor_entr INT,
									IN nome_entr VARCHAR (255),
									IN nascimento_entr DATE,
                                    IN telefone_fixo_entr VARCHAR (20),
                                    IN telefone_celular_entr VARCHAR (20),
                                    IN endereco_entr VARCHAR (200),
                                    IN salario_entr DECIMAL,
                                    IN pessoa_entr INT)
BEGIN
	UPDATE pessoa SET nome = nome_entr, nascimento = nascimento_entr, telefone_fixo = telefone_fixo_entr, 
    telefone_celular = telefone_celular_entr
    WHERE id_pessoa = pessoa_entr;
    UPDATE professor SET salario = salario_entr
    WHERE id_professor = id_professor_entr;
END $$
delimiter ;

delimiter $$
CREATE PROCEDURE inserir_crianca(IN nome_entr VARCHAR (255),
									IN nascimento_entr DATE,
                                    IN telefone_fixo_entr VARCHAR (20),
                                    IN telefone_celular_entr VARCHAR (20),
                                    IN endereco_entr VARCHAR (200),
                                    IN mae_entr VARCHAR (200),
                                    IN pai_entr VARCHAR (200),
                                    IN vacinacao_em_dia_entr VARCHAR (1),
                                    IN medicacao_controlada_entr VARCHAR (1))
BEGIN
	INSERT INTO pessoa (nome, nascimento, telefone_fixo, telefone_celular)
    VALUES (nome_entr, nascimento_entr, telefone_fixo_entr, telefone_celular_entr, endereco_entr);
    SET @pessoa_id = (SELECT id_pessoa FROM pessoa 
    WHERE nome LIKE nome_entr);
    INSERT INTO crianca (mae, pai, vacinacao_em_dia, medicacao_controlada, pessoa)
    VALUES (mae_entr, pai_entr, vacinacao_em_dia_entr, medicacao_controlada_entr, @pessoa_id);
END $$
delimiter;

delimiter $$
CREATE PROCEDURE atualizar_crianca(IN id_crianca_entr INT,
									IN nome_entr VARCHAR (255),
									IN nascimento_entr DATE,
                                    IN telefone_fixo_entr VARCHAR (20),
                                    IN telefone_celular_entr VARCHAR (20),
                                    IN mae_entr VARCHAR (200),
                                    IN pai_entr VARCHAR (200),
                                    IN vacinacao_em_dia_entr VARCHAR (1),
                                    IN medicacao_controlada_entr VARCHAR (1),
                                    IN pessoa_entr INT)
BEGIN
	UPDATE pessoa SET nome = nome_entr, nascimento = nascimento_entr, telefone_fixo = telefone_fixo_entr, 
    telefone_celular = telefone_celular_entr
    WHERE id_pessoa = pessoa_entr;
    UPDATE crianca SET mae = mae_entr, pai = pai_entr, vacinacao_em_dia = vacinacao_em_dia_entr, 
    medicacao_controlada = medicacao_controlada_entr
    WHERE id_crianca = id_crianca_entr;
END $$
delimiter ;

delimiter $$
CREATE PROCEDURE inserir_crianca_turma(IN id_crianca_entr INT, IN id_turma_entr INT)
BEGIN
	UPDATE crianca SET turma = id_turma_entr 
    WHERE id_crianca = id_crianca_entr;
END $$
delimiter ;

delimiter $$
CREATE PROCEDURE inserir_professor_turma(IN id_turma_entr INT, IN id_professor_entr INT)
BEGIN
	UPDATE turma SET professor = id_professor_entr 
    WHERE id_turma = id_turma_entr;
END $$
delimiter ;

delimiter $$
CREATE PROCEDURE inserir_doador(IN nome_entr VARCHAR (255))
BEGIN
	INSERT INTO pessoa (nome)
    VALUES (nome_entr);
    SET @pessoa_id = (SELECT id_pessoa FROM pessoa 
    WHERE nome LIKE nome_entr);
    INSERT INTO doador (pessoa)
    VALUES (@pessoa_id);
END $$
delimiter ;