Sistema Nado Livre - Controle de Toalhas

**Equipe:**
* Henzo Nunes Dias Soares
* Ryann Richard Soares Silva

A escola de natação Nado Livre oferece empréstimo de toalhas aos alunos ao final dos treinos de natação. Anteriormente, o controle manual das toalhas gerava perda delas e desorganização. 

Para solucionar isso, o nosso sistema vai automatiza o fluxo dos materiais. Com o objetivo principal de rastrear qual aluno está com qual toalha e também os funcionários envolvidos. A operação registra o momento exato da retirada (vinculando aluno, toalha e o atendente que entregou) e, posteriormente, registra a devolução (podendo ser recebida por um atendente diferente). O sistema também impede empréstimos duplicados da mesma toalha ao mesmo tempo e mantém um histórico completo para a administração.

Abaixo apresentamos o modelo lógico relacional do sistema, destacando as entidades, atributos, chaves primárias (PK), chaves estrangeiras (FK) e suas respectivas cardinalidades.

```mermaid
erDiagram
    NADADOR ||--o{ UTILIZACAO : "realiza"
    TOALHA ||--o{ UTILIZACAO : "registrada_em"
    ATENDENTE ||--o{ UTILIZACAO : "entrega"
    ATENDENTE |o--o{ UTILIZACAO : "recebe_devolucao"

    NADADOR {
        string id_nadador PK
        string nome
    }
    TOALHA {
        string id_toalha PK
        string status
    }
    ATENDENTE {
        string id_atendente PK
        string nome
    }
    UTILIZACAO {
        string id_utilizacao PK
        datetime data_hora_retirada
        datetime data_hora_devolucao
        string status
        string id_nadador FK
        string id_toalha FK
        string id_atendente_entrega FK
        string id_atendente_devolucao FK
    }
