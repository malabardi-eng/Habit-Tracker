-- Habit Tracker — tabelle nuove nello stesso progetto Supabase di "Le mie finanze",
-- con prefisso habit_ per restare completamente separate dalle tabelle finanze_*.

create table habit_activities (
  category_id text not null,
  id text not null,
  name text not null,
  custom boolean not null default false,
  primary key (category_id, id)
);

create table habit_entries (
  id uuid primary key default gen_random_uuid(),
  date date not null,
  category_id text not null,
  activity_id text not null,
  description text default '',
  duration_min integer,
  created_at timestamptz not null default now()
);

create table habit_office_days (
  date date primary key,
  slots jsonb not null default '[]',
  notes text default ''
);

create table habit_diario_days (
  date date primary key,
  text text default '',
  photo_ids jsonb not null default '[]'
);

create table habit_diario_photos (
  id uuid primary key default gen_random_uuid(),
  date date not null,
  data_url text not null,
  created_at timestamptz not null default now()
);

alter table habit_activities enable row level security;
alter table habit_entries enable row level security;
alter table habit_office_days enable row level security;
alter table habit_diario_days enable row level security;
alter table habit_diario_photos enable row level security;

create policy "habit_activities_all" on habit_activities for all using (true) with check (true);
create policy "habit_entries_all" on habit_entries for all using (true) with check (true);
create policy "habit_office_days_all" on habit_office_days for all using (true) with check (true);
create policy "habit_diario_days_all" on habit_diario_days for all using (true) with check (true);
create policy "habit_diario_photos_all" on habit_diario_photos for all using (true) with check (true);
