-- Report: Detailed list of user goals
-- This joins Users, Goals, and Frequencies

ALTER TABLE public.goal_transactions
DROP CONSTRAINT IF EXISTS goal_transactions_goal_id_fkey,
ADD CONSTRAINT goal_transactions_goal_id_fkey
  FOREIGN KEY (goal_id)
  REFERENCES public.savings_goals(goal_id)
  ON DELETE CASCADE;
