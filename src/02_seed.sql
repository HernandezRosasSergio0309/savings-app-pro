-- Savings App Pro - Seed Data
-- Project: Database Design for Savings Management
-- Version: 2.1

-- 1. Permitimos valores NULL en target_amount y end_date para las alcancías libres
ALTER TABLE public.savings_goals ALTER COLUMN target_amount DROP NOT NULL;
ALTER TABLE public.savings_goals ALTER COLUMN end_date DROP NOT NULL;

-- 2. Limpiamos TODAS las tablas en orden para evitar conflictos de llaves foráneas
TRUNCATE TABLE public.goal_transactions RESTART IDENTITY CASCADE;
TRUNCATE TABLE public.savings_goals RESTART IDENTITY CASCADE;
TRUNCATE TABLE public.frequencies RESTART IDENTITY CASCADE;

-- 3. Insertamos las Frecuencias (Tabla Padre)
INSERT INTO public.frequencies (frequency_id, frequency_name) VALUES 
(1, 'Daily'),
(2, 'Weekly'),
(3, 'Biweekly'),
(4, 'Monthly');

-- 4. Insertamos las Metas de Ahorro (Tabla Hija de Frecuencias y Profiles)
INSERT INTO public.savings_goals (goal_id, user_id, frequency_id, goal_name, target_amount, periodic_amount, start_date, end_date, is_system_goal) VALUES 
(1, '1c71c0e3-f56c-4ee1-a450-82cb7c7177ea', 4, 'General Savings', NULL, 100.00, '2026-01-01', NULL, TRUE),
(2, '1c71c0e3-f56c-4ee1-a450-82cb7c7177ea', 4, 'My Piggy Bank', NULL, 50.00, '2026-01-01', NULL, TRUE),
(3, '1c71c0e3-f56c-4ee1-a450-82cb7c7177ea', 4, 'New Laptop', 15000.00, 1250.00, '2026-01-01', '2026-12-31', FALSE),
(4, '1c71c0e3-f56c-4ee1-a450-82cb7c7177ea', 2, 'Summer Trip', 5000.00, 500.00, '2026-03-01', '2026-06-01', FALSE);

-- 5. Insertamos las Transacciones (Tabla Hija de Savings Goals)
INSERT INTO public.goal_transactions (goal_id, amount, transaction_type) VALUES 
(1, 200.00, 'deposito'),
(3, 1250.00, 'deposito'), 
(3, 1250.00, 'deposito'), 
(1, 50.00, 'retiro'), 
(4, 500.00, 'deposito');
