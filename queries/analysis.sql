-- Analysis: Progress Calculation
-- Purpose: Calculate total saved amounts and outstanding balances per goal

SELECT 
    sg.goal_name AS 'Goal',
    sg.target_amount AS 'Goal Amount',
    -- Aggregate all transactions associated with each specific goal
    IFNULL(SUM(gt.amount), 0) AS 'Total Saved',
    -- Calculate the remaining balance to reach the target
    (sg.target_amount - IFNULL(SUM(gt.amount), 0)) AS 'Remaining Balance'
FROM savings_goals sg
-- Use LEFT JOIN to include goals that don't have transactions yet
LEFT JOIN goal_transactions gt ON sg.goal_id = gt.goal_id
GROUP BY sg.goal_id, sg.goal_name, sg.target_amount;
