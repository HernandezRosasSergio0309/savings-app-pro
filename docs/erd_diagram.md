~~~mermaid
erDiagram
    USERS ||--o{ SAVINGS_GOALS : "manages"
    FREQUENCIES ||--o{ SAVINGS_GOALS : "defines"
    SAVINGS_GOALS ||--o{ GOAL_TRANSACTIONS : "records"

    USERS {
        uuid user_id PK
        text username
        text email
        text password
    }

    FREQUENCIES {
        smallint frequency_id PK
        text frequency_name
    }

    SAVINGS_GOALS {
        bigint goal_id PK
        uuid user_id FK
        smallint frequency_id FK
        text goal_name
        numeric target_amount
        numeric periodic_amount
        date start_date
        date end_date
        boolean is_system_goal
    }

    GOAL_TRANSACTIONS {
        bigint transaction_id PK
        bigint goal_id FK
        numeric amount
        transaction_type_enum transaction_type
        timestamp transaction_date
    }
~~~
