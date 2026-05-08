-- Savings App Pro - Security Configuration
-- Project: Database Design for Savings Management
-- Version: 2.0

-- 1. Creamos la tabla pública de perfiles
create table public.profiles (
  id uuid references auth.users on delete cascade not null primary key,
  username text unique not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 2. Activamos la seguridad a nivel de fila (Row Level Security)
alter table public.profiles enable row level security;

-- 3. Creamos políticas para que los usuarios puedan leer y crear sus perfiles
create policy "Public profiles are viewable by everyone."
  on profiles for select
  using ( true );

create policy "Users can insert their own profile."
  on profiles for insert
  with check ( auth.uid() = id );
