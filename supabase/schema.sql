-- Apply once in the SQL Editor of your dedicated WhoSabi project.
-- Account-owned demo state; not a public listings or tenancy database.
begin;
create table public.whosabi_workspaces (
 user_id uuid primary key references auth.users(id) on delete cascade,
 state jsonb not null check(jsonb_typeof(state) = 'object'),
 version integer not null default 0 check(version >= 0)
);
alter table public.whosabi_workspaces enable row level security;
revoke all on table public.whosabi_workspaces from anon;
grant select, insert, update on table public.whosabi_workspaces to authenticated;
create policy "Read own workspace" on public.whosabi_workspaces for select to authenticated using ((select auth.uid()) = user_id);
create policy "Create own workspace" on public.whosabi_workspaces for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "Update own workspace" on public.whosabi_workspaces for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
commit;
