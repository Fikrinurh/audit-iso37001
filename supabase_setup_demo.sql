-- SETUP SUPABASE UNTUK UJI COBA SINKRONISASI ISO 37001
-- PERINGATAN: kebijakan anon di bawah memberi akses baca/tulis tanpa login.
-- Gunakan hanya untuk uji coba. Untuk data audit produksi, implementasikan autentikasi
-- dan policies khusus authenticated sebelum aplikasi digunakan secara resmi.

alter table public.findings enable row level security;
alter table public.document_settings enable row level security;

drop policy if exists "iso37001_demo_findings_select" on public.findings;
drop policy if exists "iso37001_demo_findings_insert" on public.findings;
drop policy if exists "iso37001_demo_findings_update" on public.findings;
drop policy if exists "iso37001_demo_findings_delete" on public.findings;
create policy "iso37001_demo_findings_select" on public.findings for select to anon using (true);
create policy "iso37001_demo_findings_insert" on public.findings for insert to anon with check (true);
create policy "iso37001_demo_findings_update" on public.findings for update to anon using (true) with check (true);
create policy "iso37001_demo_findings_delete" on public.findings for delete to anon using (true);

drop policy if exists "iso37001_demo_settings_select" on public.document_settings;
drop policy if exists "iso37001_demo_settings_insert" on public.document_settings;
drop policy if exists "iso37001_demo_settings_update" on public.document_settings;
create policy "iso37001_demo_settings_select" on public.document_settings for select to anon using (true);
create policy "iso37001_demo_settings_insert" on public.document_settings for insert to anon with check (true);
create policy "iso37001_demo_settings_update" on public.document_settings for update to anon using (true) with check (true);

do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'findings'
  ) then
    alter publication supabase_realtime add table public.findings;
  end if;
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'document_settings'
  ) then
    alter publication supabase_realtime add table public.document_settings;
  end if;
end $$;
