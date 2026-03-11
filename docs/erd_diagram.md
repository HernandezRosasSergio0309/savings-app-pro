~~~mermaid
erDiagram
    USERS ||--o{ SAVINGS_GOALS : "manages"
    FREQUENCIES ||--o{ SAVINGS_GOALS : "defines"
    SAVINGS_GOALS ||--o{ GOAL_TRANSACTIONS : "records"

    USERS {
        int user_id PK
        varchar username
        varchar password
    }

    FREQUENCIES {
        tinyint frequency_id PK
        varchar frequency_name
    }

    SAVINGS_GOALS {
        int goal_id PK
        int user_id FK
        tinyint frequency_id FK
        varchar goal_name
        decimal target_amount
        decimal periodic_amount
        date start_date
        date end_date
        boolean is_system_goal
    }

    GOAL_TRANSACTIONS {
        int transaction_id PK
        int goal_id FK
        decimal amount
        timestamp transaction_date
    }
~~~
