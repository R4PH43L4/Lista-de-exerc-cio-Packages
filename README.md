# Lista-de-exerc-cio-Packages

Este documento descreve os pacotes criados para manipulação e consulta em um sistema acadêmico utilizando PL/SQL. Ele inclui funcionalidades para gerenciar disciplinas, professores e alunos, implementando procedimentos e funções robustas e eficientes.

 PKG_DISCIPLINA
Objetivo:
Gerenciar informações relacionadas a disciplinas.

Procedimentos e Funções
cadastrar_disciplina(p_nome IN VARCHAR2, p_descricao IN VARCHAR2, p_carga_horaria IN NUMBER)

Cadastra uma nova disciplina no sistema.
Validações: Verifica se o nome e a carga horária são válidos.
Transação: Confirma (COMMIT) ou reverte (ROLLBACK) alterações em caso de erro.
listar_total_alunos_disciplina

Lista o total de alunos matriculados em disciplinas com mais de 10 alunos.
listar_media_idade_disciplina(p_id_disciplina IN NUMBER)

Calcula a média de idade dos alunos de uma disciplina específica.
Validações: Verifica se o ID da disciplina é fornecido.
listar_alunos_disciplina(p_id_disciplina IN NUMBER)

Lista os alunos matriculados em uma disciplina específica.
Validações: Verifica se o ID da disciplina é válido.
 PKG_PROFESSOR
Objetivo:
Gerenciar informações relacionadas aos professores e suas turmas.

Procedimentos e Funções
listar_total_turmas

Lista o total de turmas atribuídas a cada professor, considerando apenas professores com mais de uma turma.
total_turmas_professor(p_id_professor IN NUMBER) RETURN NUMBER

Retorna o número total de turmas de um professor específico.
Validações: Verifica se o ID do professor é fornecido.
Retornos Específicos:
0 caso o professor não tenha turmas.
-1 em caso de erro.
professor_disciplina(p_id_disciplina IN NUMBER) RETURN VARCHAR2

Retorna o nome do professor responsável por uma disciplina.
Validações: Verifica se o ID da disciplina é fornecido.
PKG_ALUNO
Objetivo:
Gerenciar informações relacionadas aos alunos.

Procedimentos e Funções
excluir_aluno(p_id_aluno IN NUMBER)

Exclui um aluno e suas matrículas associadas.
Validações: Verifica se o ID do aluno é fornecido.
Transação: Confirma (COMMIT) ou reverte (ROLLBACK) alterações em caso de erro.
listar_alunos_maiores

Lista os alunos maiores de 18 anos com seus nomes e datas de nascimento.
listar_alunos_por_curso(p_id_curso IN NUMBER)

Lista os alunos matriculados em um curso específico.
Validações: Verifica se o ID do curso é fornecido.
