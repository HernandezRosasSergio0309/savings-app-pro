erDiagram
    direction LR

    USER ||--o{ GOAL : tiene
    USER ||--o{ SAVING_WITHOUT_GOAL : tiene

    USER {
        int user_id PK
        string nickname
        string pass
    }

    GOAL {
        int goal_id PK
        date start_date
        date end_date
        string savings_frequency
        float periodic_amount
        float goal_amount
        int goal_transactions
        float transaction_amount
        date transaction_date
        string goal_name
    }

    SAVING_WITHOUT_GOAL {
        int savings_id PK
        float savings_amount
        int savings_transactions
        float transaction_amount
        date transaction_date
        string savings_name
    }
