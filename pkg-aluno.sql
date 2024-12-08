CREATE OR REPLACE PACKAGE PKG_ALUNO AS
    PROCEDURE excluir_aluno(p_id_aluno IN NUMBER);
    PROCEDURE listar_alunos_maiores;
    PROCEDURE listar_alunos_por_curso(p_id_curso IN NUMBER);
END PKG_ALUNO;
/

CREATE OR REPLACE PACKAGE BODY PKG_ALUNO AS

    -- Procedure para excluir um aluno e suas matrículas associadas
    PROCEDURE excluir_aluno(p_id_aluno IN NUMBER) IS
    BEGIN
        -- Validação de entrada
        IF p_id_aluno IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'O ID do aluno é obrigatório.');
        END IF;

        DELETE FROM MATRICULA WHERE ID_ALUNO = p_id_aluno;
        DELETE FROM ALUNO WHERE ID = p_id_aluno;

        DBMS_OUTPUT.PUT_LINE('Aluno e matrículas associadas excluídos com sucesso.');
        COMMIT; -- Confirma a exclusão
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nenhum aluno encontrado com o ID informado.');
        WHEN OTHERS THEN
            ROLLBACK; -- Reverte as alterações em caso de erro
            DBMS_OUTPUT.PUT_LINE('Erro ao excluir aluno: ' || SQLERRM);
    END excluir_aluno;

    -- Procedure para listar alunos maiores de 18 anos
    PROCEDURE listar_alunos_maiores IS
    BEGIN
        FOR r IN (
            SELECT NOME, TO_CHAR(DATA_NASCIMENTO, 'DD/MM/YYYY') AS DATA_NASCIMENTO
            FROM ALUNO
            WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, DATA_NASCIMENTO) / 12) > 18
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Nome: ' || r.NOME || ' | Data de Nascimento: ' || r.DATA_NASCIMENTO);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao listar alunos maiores de 18 anos: ' || SQLERRM);
    END listar_alunos_maiores;

    -- Procedure para listar alunos de um curso específico
    PROCEDURE listar_alunos_por_curso(p_id_curso IN NUMBER) IS
    BEGIN
        -- Validação de entrada
        IF p_id_curso IS NULL THEN
            RAISE_APPLICATION_ERROR(-20002, 'O ID do curso é obrigatório.');
        END IF;

        FOR r IN (
            SELECT A.NOME
            FROM ALUNO A
            JOIN MATRICULA M ON A.ID = M.ID_ALUNO
            WHERE M.ID_CURSO = p_id_curso
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Nome: ' || r.NOME);
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nenhum aluno encontrado para o curso informado.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao listar alunos do curso: ' || SQLERRM);
    END listar_alunos_por_curso;

END PKG_ALUNO;
/
