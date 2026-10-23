-- Expo Floor Manager: database, authentication roles, RLS, realtime, and seed data.

create extension if not exists pgcrypto;

do $$
begin
  create type public.app_role as enum ('viewer', 'manager', 'admin');
exception
  when duplicate_object then null;
end $$;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  role public.app_role not null default 'viewer',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.vendors (
  id text primary key default gen_random_uuid()::text,
  name text not null,
  booths text[] not null check (cardinality(booths) > 0),
  contact text not null default '',
  phone text not null default '',
  updated_at timestamptz not null default now(),
  updated_by uuid references auth.users(id)
);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = public, pg_temp
as $$
begin
  new.updated_at = now();
  new.updated_by = auth.uid();
  return new;
end;
$$;

drop trigger if exists vendors_set_updated_at on public.vendors;
create trigger vendors_set_updated_at
before update on public.vendors
for each row execute function public.set_updated_at();

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  insert into public.profiles (id, display_name)
  values (new.id, coalesce(new.raw_user_meta_data ->> 'display_name', new.email));
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

create or replace function public.current_user_role()
returns public.app_role
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select role from public.profiles where id = auth.uid();
$$;

alter table public.profiles enable row level security;
alter table public.vendors enable row level security;

drop policy if exists profiles_read_self_or_admin on public.profiles;
create policy profiles_read_self_or_admin
on public.profiles for select
to authenticated
using (id = auth.uid() or public.current_user_role() = 'admin');

drop policy if exists profiles_admin_update on public.profiles;
create policy profiles_admin_update
on public.profiles for update
to authenticated
using (public.current_user_role() = 'admin')
with check (public.current_user_role() = 'admin');

drop policy if exists vendors_authenticated_read on public.vendors;
create policy vendors_authenticated_read
on public.vendors for select
to authenticated
using (true);

drop policy if exists vendors_manager_insert on public.vendors;
create policy vendors_manager_insert
on public.vendors for insert
to authenticated
with check (public.current_user_role() in ('manager', 'admin'));

drop policy if exists vendors_manager_update on public.vendors;
create policy vendors_manager_update
on public.vendors for update
to authenticated
using (public.current_user_role() in ('manager', 'admin'))
with check (public.current_user_role() in ('manager', 'admin'));

drop policy if exists vendors_admin_delete on public.vendors;
create policy vendors_admin_delete
on public.vendors for delete
to authenticated
using (public.current_user_role() = 'admin');

grant usage on schema public to authenticated;
grant select on public.profiles to authenticated;
grant update (display_name, role) on public.profiles to authenticated;
grant select, insert, update, delete on public.vendors to authenticated;
grant execute on function public.current_user_role() to authenticated;

insert into public.vendors (id, name, booths, contact, phone) values
('1','Amplify Wellness',array['200'],'',''),
('2','APeX-Water Research Institute',array['312'],'',''),
('3','Atlas Clinics',array['505'],'',''),
('4','Baja Gold Sea Salt',array['405'],'',''),
('5','Ben Azadi',array['618'],'',''),
('6','The Better Brain Company',array['511','511'],'',''),
('7','Boss Cow',array['407'],'',''),
('8','Brandlin for Nevada',array['219'],'',''),
('9','Cambiotics ApS',array['519'],'',''),
('10','Carnivore Coach International',array['112'],'',''),
('11','Core Integrative Wellness',array['410'],'',''),
('12','Crystal MedTech, LLC',array['506'],'',''),
('13','Debbie Potts Coaching',array['619'],'',''),
('14','DetoxPure',array['504'],'',''),
('15','Dr. Gogol Health and Wellness',array['617'],'',''),
('16','Dr.Fuji',array['300'],'',''),
('17','Dreamwalkerz',array['302','302'],'',''),
('18','Farrow',array['201'],'',''),
('19','Fixxr Formulas',array['402'],'',''),
('20','Flowpresso',array['310'],'',''),
('21','Godspeed',array['604'],'',''),
('22','Good Idea',array['510'],'',''),
('23','Green Pasture',array['600'],'',''),
('24','H-Wave',array['502'],'',''),
('25','Hair by Mermaid',array['106'],'',''),
('26','Happy Caapi',array['415'],'',''),
('27','Healing Humanity',array['114'],'',''),
('28','Health on the Horizon',array['215'],'',''),
('29','HomeCleanse',array['100'],'',''),
('30','I Fix Hearts',array['203'],'',''),
('31','Inhale H2 Ltd',array['311'],'',''),
('32','Keto Mojo',array['204'],'',''),
('33','Kiltz Health LLC',array['317'],'',''),
('34','Kure-it BibleHealingOil.com',array['400'],'',''),
('35','Lifespanning Magazine',array['512'],'',''),
('36','The Light System',array['307'],'',''),
('37','The Low Carb Consultant',array['116'],'',''),
('38','Miller''s Bio Farm',array['507'],'',''),
('39','Mimio Health',array['411'],'',''),
('40','MotherFoCare',array['211'],'',''),
('41','Nutrition Network',array['315'],'',''),
('42','Peak Saunas',array['413'],'',''),
('43','Peluva',array['304'],'',''),
('44','Plainview Beef',array['501'],'',''),
('45','Primal Pals',array['414'],'',''),
('46','Proven Proteins',array['213'],'',''),
('47','Purely Tallow LLC',array['305'],'',''),
('48','Rapid Release',array['401'],'',''),
('49','Recharge Health',array['514'],'',''),
('50','Redmond Real Salt',array['314'],'',''),
('51','Relax Saunas',array['303'],'',''),
('52','SALTR',array['210'],'',''),
('53','Share Swiss',array['607'],'',''),
('54','Shielded Healing & The Shielding Shop',array['110'],'',''),
('55','Spectra Wellness',array['516'],'',''),
('56','SplitMart',array['503'],'',''),
('57','Summus Laser Pod',array['102'],'',''),
('58','Surgically Clean Air',array['500'],'',''),
('59','TaliaGen',array['403'],'',''),
('60','Vibrant Health Systems',array['609'],'',''),
('61','VORG superfoods',array['218'],'',''),
('62','Weston A. Price Foundation',array['602'],'',''),
('63','WeVibin',array['518'],'',''),
('64','Wysdom',array['301'],'',''),
('65','Zero Gravity',array['601'],'','')
on conflict (id) do update set
  name = excluded.name,
  booths = excluded.booths;

do $$
begin
  alter publication supabase_realtime add table public.vendors;
exception
  when duplicate_object then null;
end $$;
