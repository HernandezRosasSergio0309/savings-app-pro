-- Report: Detailed list of user goals

ALTER TABLE public.goal_transactions
DROP CONSTRAINT IF EXISTS goal_transactions_goal_id_fkey,
ADD CONSTRAINT goal_transactions_goal_id_fkey
  FOREIGN KEY (goal_id)
  REFERENCES public.savings_goals(goal_id)
  ON DELETE CASCADE;
-- Permitir que usuarios autenticados lean las metas
CREATE POLICY "Enable read access for all users on goals" 
ON public.savings_goals FOR SELECT 
USING (true);

-- Permitir leer las transacciones
CREATE POLICY "Enable read access for all users on transactions" 
ON public.goal_transactions FOR SELECT 
USING (true);

CREATE POLICY "Permitir insertar metas" 
ON public.savings_goals FOR INSERT 
WITH CHECK (true);

CREATE POLICY "Permitir insertar transacciones" 
ON public.goal_transactions FOR INSERT 
WITH CHECK (true);

-- Función para borrar al usuario actual y todo su rastro
create or replace function delete_user()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  -- Borramos al usuario de la tabla auth.users
  -- Supabase se encargará de cerrar la sesión automáticamente
  delete from auth.users where id = auth.uid();
end;
$$;

-- Función que copia los datos de auth.users a public.profiles
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, username)
  values (
    new.id, 
    new.raw_user_meta_data->>'username' -- Aquí sacamos el nombre que mandamos desde Flutter
  );
  return new;
end;
$$;

-- El Trigger que se dispara automáticamente al insertar en auth.users
create or replace trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- Creamos la función que tomará los datos del nuevo usuario
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, username)
  values (
    new.id, 
    new.raw_user_meta_data->>'username' -- Extrae el 'username' que mandamos desde Flutter
  );
  return new;
end;
$$;

-- Creamos el Trigger que vigila cuándo se registra alguien
create or replace trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
