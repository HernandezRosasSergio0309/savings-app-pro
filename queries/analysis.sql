-- Analysis: Progress Calculation
-- Purpose: Calculate total saved amounts and outstanding balances per goal

SELECT 
    Goal,
    Goal_Amount,
    Current_Balance,
    CASE 
        WHEN Goal_Amount = 0 THEN 0
        ELSE (Goal_Amount - Current_Balance) 
    END AS Remaining_Balance
FROM (
    -- Subquery that calculates the net balance first
    SELECT 
        sg.goal_name AS Goal,
        IFNULL(sg.target_amount, 0) AS Goal_Amount,
        SUM(CASE 
            WHEN gt.transaction_type = 'deposit' THEN gt.amount 
            WHEN gt.transaction_type = 'withdrawal' THEN -gt.amount 
            ELSE 0 
        END) AS Current_Balance
    FROM savings_goals sg
    LEFT JOIN goal_transactions gt ON sg.goal_id = gt.goal_id
    GROUP BY sg.goal_id, sg.goal_name, sg.target_amount
) AS summary;
