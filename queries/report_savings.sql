-- Report: Detailed list of user goals
-- This joins Users, Goals, and Frequencies

SELECT 
    u.username AS 'User',
    sg.goal_name AS 'Goal',
    sg.target_amount AS 'Target',
    f.frequency_name AS 'Save Interval',
    sg.start_date AS 'Starts',
    sg.end_date AS 'Deadline'
FROM users u
INNER JOIN savings_goals sg ON u.user_id = sg.user_id
INNER JOIN frequencies f ON sg.frequency_id = f.frequency_id;
