-- 001_create_metadata_tables.sql

-- Files tracked in the project
CREATE TABLE IF NOT EXISTS files (
  id SERIAL PRIMARY KEY,
  path TEXT NOT NULL,
  sha256 TEXT NOT NULL,
  added_by TEXT NOT NULL,
  added_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Bots registered under OrchestratorBot
CREATE TABLE IF NOT EXISTS bots (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  domain TEXT NOT NULL,
  repo_url TEXT,
  status TEXT NOT NULL DEFAULT 'pending',
  registered_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ChatGPT automations and HelperBots schedules
CREATE TABLE IF NOT EXISTS automations (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  type TEXT NOT NULL,           -- e.g. 'chatgpt', 'helperbot'
  schedule TEXT NOT NULL,       -- iCal RRULE or cron
  last_run TIMESTAMPTZ,
  next_run TIMESTAMPTZ
);

-- Activity log of all actions
CREATE TABLE IF NOT EXISTS activities (
  id SERIAL PRIMARY KEY,
  occurred_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  actor TEXT NOT NULL,
  action_type TEXT NOT NULL,
  details JSONB
);
