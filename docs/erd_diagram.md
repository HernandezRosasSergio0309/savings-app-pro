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
        int2 frequency_id PK
        text frequency_name
    }

    SAVINGS_GOALS {
        int8 goal_id PK
        uuid user_id FK
        int2 frequency_id FK
        text goal_name
        numeric target_amount
        numeric periodic_amount
        date start_date
        date end_date
        bool is_system_goal
    }

    GOAL_TRANSACTIONS {
        int8 transaction_id PK
        int8 goal_id FK
        numeric amount
        transaction_type_enum transaction_type
        timestamptz transaction_date
    }
~~~
