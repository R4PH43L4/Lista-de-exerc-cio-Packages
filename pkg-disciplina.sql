CREATE OR REPLACE PACKAGE PKG_DISCIPLINA AS
    PROCEDURE cadastrar_disciplina(p_nome IN VARCHAR2, p_descricao IN VARCHAR2, p_carga_horaria IN NUMBER);
    PROCEDURE listar_total_alunos_disciplina;
    PROCEDURE listar_media_idade_disciplina(p_id_disciplina IN NUMBER);
    PROCEDURE listar_alunos_disciplina(p_id_disciplina IN NUMBER);
END PKG_DISCIPLINA;
/

CREATE OR REPLACE PACKAGE BODY PKG_DISCIPLINA AS

    -- Procedure para cadastro de disciplina
    PROCEDURE cadastrar_disciplina(p_nome IN VARCHAR2, p_descricao IN VARCHAR2, p_carga_horaria IN NUMBER) IS
    BEGIN
        -- Validação de entrada
        IF p_nome IS NULL OR p_carga_horaria <= 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Dados inválidos para cadastro de disciplina.');
        END IF;

        INSERT INTO DISCIPLINA (NOME, DESCRICAO, CARGA_HORARIA)
        VALUES (p_nome, p_descricao, p_carga_horaria);

        DBMS_OUTPUT.PUT_LINE('Disciplina cadastrada com sucesso.');
        COMMIT; -- Confirma a transação
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK; -- Desfaz a transação em caso de erro
            DBMS_OUTPUT.PUT_LINE('Erro ao cadastrar disciplina: ' || SQLERRM);
    END cadastrar_disciplina;

    -- Procedure para listar total de alunos por disciplina
    PROCEDURE listar_total_alunos_disciplina IS
    BEGIN
        FOR r IN (
            SELECT D.NOME, COUNT(M.ID_ALUNO) AS TOTAL_ALUNOS
            FROM DISCIPLINA D
            JOIN MATRICULA M ON D.ID = M.ID_DISCIPLINA
            GROUP BY D.NOME
            HAVING COUNT(M.ID_ALUNO) > 10
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Disciplina: ' || r.NOME || ' | Total de Alunos: ' || r.TOTAL_ALUNOS);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao listar total de alunos: ' || SQLERRM);
    END listar_total_alunos_disciplina;

    -- Procedure para listar média de idade dos alunos em uma disciplina
    PROCEDURE listar_media_idade_disciplina(p_id_disciplina IN NUMBER) IS
        v_media_idade NUMBER;
    BEGIN
        -- Validação de entrada
        IF p_id_disciplina IS NULL THEN
            RAISE_APPLICATION_ERROR(-20002, 'ID da disciplina é obrigatório.');
        END IF;

        SELECT AVG(TRUNC(MONTHS_BETWEEN(SYSDATE, A.DATA_NASCIMENTO) / 12))
        INTO v_media_idade
        FROM ALUNO A
        JOIN MATRICULA M ON A.ID = M.ID_ALUNO
        WHERE M.ID_DISCIPLINA = p_id_disciplina;

        IF v_media_idade IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Nenhum aluno encontrado para a disciplina informada.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Média de Idade: ' || v_media_idade);
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Disciplina não encontrada ou sem alunos matriculados.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao calcular média de idade: ' || SQLERRM);
    END listar_media_idade_disciplina;

    -- Procedure para listar alunos de uma disciplina
    PROCEDURE listar_alunos_disciplina(p_id_disciplina IN NUMBER) IS
    BEGIN
        -- Validação de entrada
        IF p_id_disciplina IS NULL THEN
            RAISE_APPLICATION_ERROR(-20003, 'ID da disciplina é obrigatório.');
        END IF;

        FOR r IN (
            SELECT A.NOME
            FROM ALUNO A
            JOIN MATRICULA M ON A.ID = M.ID_ALUNO
            WHERE M.ID_DISCIPLINA = p_id_disciplina
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Nome: ' || r.NOME);
        END LOOP;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nenhum aluno encontrado para a disciplina informada.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao listar alunos: ' || SQLERRM);
    END listar_alunos_disciplina;

END PKG_DISCIPLINA;
