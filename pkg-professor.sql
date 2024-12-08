CREATE OR REPLACE PACKAGE PKG_PROFESSOR AS
    PROCEDURE listar_total_turmas;
    FUNCTION total_turmas_professor(p_id_professor IN NUMBER) RETURN NUMBER;
    FUNCTION professor_disciplina(p_id_disciplina IN NUMBER) RETURN VARCHAR2;
END PKG_PROFESSOR;
/

CREATE OR REPLACE PACKAGE BODY PKG_PROFESSOR AS

    -- Procedure para listar o total de turmas por professor
    PROCEDURE listar_total_turmas IS
    BEGIN
        FOR r IN (
            SELECT P.NOME AS NOME_PROFESSOR, COUNT(T.ID) AS TOTAL_TURMAS
            FROM PROFESSOR P
            JOIN TURMA T ON P.ID = T.ID_PROFESSOR
            GROUP BY P.NOME
            HAVING COUNT(T.ID) > 1
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Professor: ' || r.NOME_PROFESSOR || ' | Total de Turmas: ' || r.TOTAL_TURMAS);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao listar total de turmas: ' || SQLERRM);
    END listar_total_turmas;

    -- Function para obter o total de turmas de um professor
    FUNCTION total_turmas_professor(p_id_professor IN NUMBER) RETURN NUMBER IS
        v_total NUMBER := 0;
    BEGIN
        -- Validação de entrada
        IF p_id_professor IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'O ID do professor é obrigatório.');
        END IF;

        SELECT COUNT(ID) 
        INTO v_total
        FROM TURMA
        WHERE ID_PROFESSOR = p_id_professor;

        RETURN v_total;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0; -- Retorna 0 caso o professor não tenha turmas
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao obter total de turmas: ' || SQLERRM);
            RETURN -1; -- Retorna -1 para indicar erro
    END total_turmas_professor;

    -- Function para obter o nome do professor responsável por uma disciplina
    FUNCTION professor_disciplina(p_id_disciplina IN NUMBER) RETURN VARCHAR2 IS
        v_nome_professor VARCHAR2(100);
    BEGIN
        -- Validação de entrada
        IF p_id_disciplina IS NULL THEN
            RAISE_APPLICATION_ERROR(-20002, 'O ID da disciplina é obrigatório.');
        END IF;

        SELECT P.NOME
        INTO v_nome_professor
        FROM PROFESSOR P
        JOIN TURMA T ON P.ID = T.ID_PROFESSOR
        JOIN DISCIPLINA D ON T.ID_DISCIPLINA = D.ID
        WHERE D.ID = p_id_disciplina;

        RETURN v_nome_professor;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'Nenhum professor encontrado para a disciplina informada.';
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao obter professor da disciplina: ' || SQLERRM);
            RETURN 'Erro ao buscar o professor.';
    END professor_disciplina;

END PKG_PROFESSOR;
/
