const express = require('express');
const path = require('path');
const crypto = require('crypto');
const { Pool } = require('pg');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json({ limit: '20mb' }));
app.use(express.static(path.join(__dirname, 'public')));

// ── DATABASE ──────────────────────────────────────────
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

async function initDB() {
  await pool.query(`
    -- ═══════════════════════════════════════
    -- ANALYTICS MODULE (existing)
    -- ═══════════════════════════════════════
    CREATE TABLE IF NOT EXISTS clients (
      id SERIAL PRIMARY KEY,
      name TEXT NOT NULL,
      mazine_start_date DATE,
      created_at TIMESTAMPTZ DEFAULT NOW()
    );

    CREATE TABLE IF NOT EXISTS reports (
      id SERIAL PRIMARY KEY,
      client_id INTEGER REFERENCES clients(id) ON DELETE CASCADE,
      month_key TEXT NOT NULL,
      ai_result JSONB,
      created_at TIMESTAMPTZ DEFAULT NOW(),
      updated_at TIMESTAMPTZ DEFAULT NOW(),
      UNIQUE(client_id, month_key)
    );

    CREATE TABLE IF NOT EXISTS tiktok_overview (
      client_id INTEGER REFERENCES clients(id) ON DELETE CASCADE,
      date DATE NOT NULL,
      views INTEGER DEFAULT 0,
      likes INTEGER DEFAULT 0,
      comments INTEGER DEFAULT 0,
      shares INTEGER DEFAULT 0,
      updated_at TIMESTAMPTZ DEFAULT NOW(),
      PRIMARY KEY (client_id, date)
    );

    CREATE TABLE IF NOT EXISTS tiktok_followers (
      client_id INTEGER REFERENCES clients(id) ON DELETE CASCADE,
      date DATE NOT NULL,
      followers INTEGER DEFAULT 0,
      diff INTEGER DEFAULT 0,
      updated_at TIMESTAMPTZ DEFAULT NOW(),
      PRIMARY KEY (client_id, date)
    );

    CREATE TABLE IF NOT EXISTS tiktok_viewers (
      client_id INTEGER REFERENCES clients(id) ON DELETE CASCADE,
      date DATE NOT NULL,
      new_viewers INTEGER DEFAULT 0,
      returning_viewers INTEGER DEFAULT 0,
      updated_at TIMESTAMPTZ DEFAULT NOW(),
      PRIMARY KEY (client_id, date)
    );

    CREATE TABLE IF NOT EXISTS tiktok_activity (
      client_id INTEGER REFERENCES clients(id) ON DELETE CASCADE,
      date DATE NOT NULL,
      hour SMALLINT NOT NULL,
      active_followers INTEGER DEFAULT 0,
      updated_at TIMESTAMPTZ DEFAULT NOW(),
      PRIMARY KEY (client_id, date, hour)
    );

    CREATE TABLE IF NOT EXISTS tiktok_content (
      client_id INTEGER REFERENCES clients(id) ON DELETE CASCADE,
      title TEXT NOT NULL,
      views INTEGER DEFAULT 0,
      likes INTEGER DEFAULT 0,
      comments INTEGER DEFAULT 0,
      shares INTEGER DEFAULT 0,
      post_time TEXT,
      updated_at TIMESTAMPTZ DEFAULT NOW(),
      PRIMARY KEY (client_id, title)
    );

    CREATE TABLE IF NOT EXISTS tiktok_gender (
      client_id INTEGER REFERENCES clients(id) ON DELETE CASCADE,
      gender TEXT NOT NULL,
      distribution NUMERIC(6,2) DEFAULT 0,
      updated_at TIMESTAMPTZ DEFAULT NOW(),
      PRIMARY KEY (client_id, gender)
    );

    CREATE TABLE IF NOT EXISTS tiktok_territories (
      client_id INTEGER REFERENCES clients(id) ON DELETE CASCADE,
      territory TEXT NOT NULL,
      distribution NUMERIC(8,4) DEFAULT 0,
      updated_at TIMESTAMPTZ DEFAULT NOW(),
      PRIMARY KEY (client_id, territory)
    );

    -- ═══════════════════════════════════════
    -- BUSINESS MODULE (new)
    -- ═══════════════════════════════════════

    -- Team members with hourly rates
    CREATE TABLE IF NOT EXISTS team_members (
      id SERIAL PRIMARY KEY,
      name TEXT NOT NULL,
      role TEXT,
      hourly_rate NUMERIC(8,2) NOT NULL DEFAULT 0,
      color TEXT DEFAULT '#618F9B',
      active BOOLEAN DEFAULT true,
      created_at TIMESTAMPTZ DEFAULT NOW()
    );

    -- Business client profiles (linked to analytics clients)
    CREATE TABLE IF NOT EXISTS client_contracts (
      id SERIAL PRIMARY KEY,
      client_id INTEGER REFERENCES clients(id) ON DELETE CASCADE,
      package TEXT,                          -- Starter / Growth / Performance / Custom
      mrr NUMERIC(10,2) DEFAULT 0,           -- Monthly Recurring Revenue (MUR)
      hours_sold_per_month NUMERIC(6,1) DEFAULT 0,
      contract_start DATE,
      contract_end DATE,
      status TEXT DEFAULT 'active',          -- active / paused / churned
      contact_name TEXT,
      contact_phone TEXT,
      contact_email TEXT,
      notes TEXT,
      updated_at TIMESTAMPTZ DEFAULT NOW()
    );

    -- Content production items (each video = one item)
    CREATE TABLE IF NOT EXISTS content_items (
      id SERIAL PRIMARY KEY,
      client_id INTEGER REFERENCES clients(id) ON DELETE CASCADE,
      title TEXT NOT NULL,
      status TEXT DEFAULT 'brief',           -- brief / script / shooting / editing / validation / posted / boosted
      hook_type TEXT,                        -- Educational / Story / Trend / Offer
      objective TEXT,                        -- Brand / Lead / Conversion
      format TEXT,                           -- UGC / FaceCam / Voiceover / Interview
      cta_type TEXT,
      shoot_date DATE,
      post_date DATE,
      assigned_to INTEGER REFERENCES team_members(id),
      tiktok_views INTEGER,
      tiktok_likes INTEGER,
      tiktok_shares INTEGER,
      performance_score NUMERIC(4,1),
      notes TEXT,
      created_at TIMESTAMPTZ DEFAULT NOW(),
      updated_at TIMESTAMPTZ DEFAULT NOW()
    );

    -- Time tracking entries
    CREATE TABLE IF NOT EXISTS time_entries (
      id SERIAL PRIMARY KEY,
      team_member_id INTEGER REFERENCES team_members(id) ON DELETE CASCADE,
      client_id INTEGER REFERENCES clients(id) ON DELETE CASCADE,
      content_item_id INTEGER REFERENCES content_items(id) ON DELETE SET NULL,
      task_type TEXT NOT NULL,               -- strategy / script / shooting / editing / publishing / meeting / admin
      hours NUMERIC(5,2) NOT NULL,
      date DATE NOT NULL DEFAULT CURRENT_DATE,
      notes TEXT,
      created_at TIMESTAMPTZ DEFAULT NOW()
    );

    -- Leads (lightweight CRM)
    CREATE TABLE IF NOT EXISTS leads (
      id SERIAL PRIMARY KEY,
      company TEXT NOT NULL,
      contact_name TEXT,
      phone TEXT,
      email TEXT,
      source TEXT DEFAULT 'referral',
      status TEXT DEFAULT 'new',
      estimated_mrr NUMERIC(10,2),
      service_type TEXT,
      probability INTEGER DEFAULT 20,
      close_date DATE,
      owner_id INTEGER REFERENCES team_members(id),
      next_action_date DATE,
      notes TEXT,
      created_at TIMESTAMPTZ DEFAULT NOW(),
      updated_at TIMESTAMPTZ DEFAULT NOW()
    );

    -- Content tasks (auto-created per video, one per stage)
    CREATE TABLE IF NOT EXISTS content_tasks (
      id SERIAL PRIMARY KEY,
      content_item_id INTEGER REFERENCES content_items(id) ON DELETE CASCADE,
      client_id INTEGER REFERENCES clients(id) ON DELETE CASCADE,
      stage TEXT NOT NULL,          -- ideas / script / shooting / editing / ready / posted / boosted
      title TEXT NOT NULL,
      assigned_to INTEGER REFERENCES team_members(id),
      default_hours NUMERIC(5,2) DEFAULT 0,
      status TEXT DEFAULT 'todo',   -- todo / in_progress / done / skipped
      due_date DATE,
      done_at TIMESTAMPTZ,
      notes TEXT,
      created_at TIMESTAMPTZ DEFAULT NOW()
    );

    -- Task default durations (configurable per team)
    CREATE TABLE IF NOT EXISTS task_defaults (
      stage TEXT PRIMARY KEY,
      label TEXT NOT NULL,
      emoji TEXT DEFAULT '📋',
      default_hours NUMERIC(5,2) DEFAULT 1,
      sort_order INTEGER DEFAULT 0
    );

    -- Seed default durations if not present
    INSERT INTO task_defaults (stage, label, emoji, default_hours, sort_order) VALUES
      ('ideas',    'Idéation',       '💡', 1.0, 1),
      ('script',   'Script',         '✍',  2.0, 2),
      ('shooting', 'Tournage',       '🎬', 4.0, 3),
      ('editing',  'Montage',        '🎞', 3.0, 4),
      ('ready',    'Ready to Post',  '📲', 0.5, 5),
      ('posted',   'Publication',    '📈', 0.5, 6),
      ('boosted',  'Boost Ads',      '🔥', 1.0, 7)
    ON CONFLICT (stage) DO NOTHING;
  `);
  console.log('DB ready');
}

initDB().catch(err => console.error('DB init error:', err));

// ── SESSION ───────────────────────────────────────────
const sessions = new Map();
const SESSION_TTL = 8 * 60 * 60 * 1000;

function createToken() { return crypto.randomBytes(32).toString('hex'); }

function isAuthenticated(req) {
  const token = (req.headers['authorization'] || '').replace('Bearer ', '').trim();
  if (!token) return false;
  const expiry = sessions.get(token);
  if (!expiry || Date.now() > expiry) { sessions.delete(token); return false; }
  return true;
}

function auth(req, res, next) {
  if (!isAuthenticated(req)) return res.status(401).json({ error: 'Non authentifié.' });
  next();
}

// ── AUTH ──────────────────────────────────────────────
app.post('/api/login', (req, res) => {
  const { password } = req.body;
  const expected = process.env.APP_PASSWORD;
  if (!expected) return res.status(500).json({ error: 'APP_PASSWORD not configured.' });
  if (password !== expected) return res.status(401).json({ error: 'Mot de passe incorrect.' });
  const token = createToken();
  sessions.set(token, Date.now() + SESSION_TTL);
  res.json({ token });
});

app.post('/api/logout', (req, res) => {
  sessions.delete((req.headers['authorization'] || '').replace('Bearer ', '').trim());
  res.json({ ok: true });
});

// ── ANALYTICS CLIENTS ─────────────────────────────────
app.get('/api/clients', auth, async (req, res) => {
  try {
    const { rows } = await pool.query(`
      SELECT c.id, c.name, c.mazine_start_date,
        cc.mrr, cc.package, cc.status as contract_status, cc.hours_sold_per_month,
        (SELECT MAX(updated_at) FROM tiktok_overview WHERE client_id=c.id) as last_upload
      FROM clients c
      LEFT JOIN client_contracts cc ON cc.client_id = c.id
      ORDER BY c.name ASC`);
    res.json({ clients: rows });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.post('/api/clients', auth, async (req, res) => {
  const { name, mazine_start_date } = req.body;
  if (!name?.trim()) return res.status(400).json({ error: 'Nom requis.' });
  try {
    const { rows } = await pool.query(
      'INSERT INTO clients (name, mazine_start_date) VALUES ($1, $2) RETURNING id, name, mazine_start_date',
      [name.trim(), mazine_start_date || null]
    );
    res.json({ client: rows[0] });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.put('/api/clients/:id', auth, async (req, res) => {
  const { name, mazine_start_date } = req.body;
  try {
    const { rows } = await pool.query(
      'UPDATE clients SET name=$1, mazine_start_date=$2 WHERE id=$3 RETURNING id, name, mazine_start_date',
      [name.trim(), mazine_start_date || null, req.params.id]
    );
    if (!rows.length) return res.status(404).json({ error: 'Client introuvable.' });
    res.json({ client: rows[0] });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.delete('/api/clients/:id', auth, async (req, res) => {
  try {
    await pool.query('DELETE FROM clients WHERE id=$1', [req.params.id]);
    res.json({ ok: true });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── TIKTOK DATA ───────────────────────────────────────
app.post('/api/clients/:id/data', auth, async (req, res) => {
  const clientId = req.params.id;
  const { overview, followers, viewers, activity, content, gender, territories } = req.body;
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    if (overview?.length) {
      for (const row of overview) {
        if (!row.date) continue;
        await client.query(`INSERT INTO tiktok_overview (client_id,date,views,likes,comments,shares,updated_at) VALUES ($1,$2,$3,$4,$5,$6,NOW()) ON CONFLICT (client_id,date) DO UPDATE SET views=$3,likes=$4,comments=$5,shares=$6,updated_at=NOW()`,
          [clientId, row.date, row.views||0, row.likes||0, row.comments||0, row.shares||0]);
      }
    }
    if (followers?.length) {
      for (const row of followers) {
        if (!row.date) continue;
        await client.query(`INSERT INTO tiktok_followers (client_id,date,followers,diff,updated_at) VALUES ($1,$2,$3,$4,NOW()) ON CONFLICT (client_id,date) DO UPDATE SET followers=$3,diff=$4,updated_at=NOW()`,
          [clientId, row.date, row.followers||0, row.diff||0]);
      }
    }
    if (viewers?.length) {
      for (const row of viewers) {
        if (!row.date) continue;
        await client.query(`INSERT INTO tiktok_viewers (client_id,date,new_viewers,returning_viewers,updated_at) VALUES ($1,$2,$3,$4,NOW()) ON CONFLICT (client_id,date) DO UPDATE SET new_viewers=$3,returning_viewers=$4,updated_at=NOW()`,
          [clientId, row.date, row.newV||0, row.returning||0]);
      }
    }
    if (activity?.length) {
      for (const row of activity) {
        if (!row.date) continue;
        await client.query(`INSERT INTO tiktok_activity (client_id,date,hour,active_followers,updated_at) VALUES ($1,$2,$3,$4,NOW()) ON CONFLICT (client_id,date,hour) DO UPDATE SET active_followers=$4,updated_at=NOW()`,
          [clientId, row.date, row.hour||0, row.active||0]);
      }
    }
    if (content?.length) {
      for (const row of content) {
        if (!row.title) continue;
        await client.query(`INSERT INTO tiktok_content (client_id,title,views,likes,comments,shares,post_time,updated_at) VALUES ($1,$2,$3,$4,$5,$6,$7,NOW()) ON CONFLICT (client_id,title) DO UPDATE SET views=$3,likes=$4,comments=$5,shares=$6,post_time=$7,updated_at=NOW()`,
          [clientId, row.title, row.views||0, row.likes||0, row.comments||0, row.shares||0, row.postTime||null]);
      }
    }
    if (gender?.length) {
      await client.query('DELETE FROM tiktok_gender WHERE client_id=$1', [clientId]);
      for (const row of gender) {
        if (!row.gender) continue;
        await client.query(`INSERT INTO tiktok_gender (client_id,gender,distribution,updated_at) VALUES ($1,$2,$3,NOW()) ON CONFLICT (client_id,gender) DO UPDATE SET distribution=$3,updated_at=NOW()`,
          [clientId, row.gender, row.dist||0]);
      }
    }
    if (territories?.length) {
      await client.query('DELETE FROM tiktok_territories WHERE client_id=$1', [clientId]);
      for (const row of territories) {
        if (!row.territory) continue;
        await client.query(`INSERT INTO tiktok_territories (client_id,territory,distribution,updated_at) VALUES ($1,$2,$3,NOW()) ON CONFLICT (client_id,territory) DO UPDATE SET distribution=$3,updated_at=NOW()`,
          [clientId, row.territory, row.dist||0]);
      }
    }
    await client.query('COMMIT');
    res.json({ ok: true, saved: { overview: overview?.length||0, followers: followers?.length||0, viewers: viewers?.length||0, activity: activity?.length||0, content: content?.length||0, gender: gender?.length||0, territories: territories?.length||0 }});
  } catch (err) {
    await client.query('ROLLBACK');
    res.status(500).json({ error: err.message });
  } finally { client.release(); }
});

app.get('/api/clients/:id/data', auth, async (req, res) => {
  const clientId = req.params.id;
  try {
    const [ov, fol, view, act, cont, gen, ter] = await Promise.all([
      pool.query('SELECT date,views,likes,comments,shares FROM tiktok_overview WHERE client_id=$1 ORDER BY date ASC', [clientId]),
      pool.query('SELECT date,followers,diff FROM tiktok_followers WHERE client_id=$1 ORDER BY date ASC', [clientId]),
      pool.query('SELECT date,new_viewers,returning_viewers FROM tiktok_viewers WHERE client_id=$1 ORDER BY date ASC', [clientId]),
      pool.query('SELECT date,hour,active_followers FROM tiktok_activity WHERE client_id=$1 ORDER BY date ASC,hour ASC', [clientId]),
      pool.query('SELECT title,views,likes,comments,shares,post_time FROM tiktok_content WHERE client_id=$1 ORDER BY views DESC', [clientId]),
      pool.query('SELECT gender,distribution FROM tiktok_gender WHERE client_id=$1', [clientId]),
      pool.query('SELECT territory,distribution FROM tiktok_territories WHERE client_id=$1 ORDER BY distribution DESC', [clientId]),
    ]);
    res.json({
      hasData: ov.rowCount + fol.rowCount + cont.rowCount > 0,
      overview: ov.rows.map(r=>({dateRaw:r.date,date:r.date,views:+r.views,likes:+r.likes,comments:+r.comments,shares:+r.shares})),
      followers: fol.rows.map(r=>({dateRaw:r.date,date:r.date,followers:+r.followers,diff:+r.diff})),
      viewers: view.rows.map(r=>({dateRaw:r.date,date:r.date,newV:+r.new_viewers,returning:+r.returning_viewers})),
      activity: act.rows.map(r=>({dateRaw:r.date,date:r.date,hour:+r.hour,active:+r.active_followers})),
      content: cont.rows.map(r=>({title:r.title,views:+r.views,likes:+r.likes,comments:+r.comments,shares:+r.shares,postTime:r.post_time})),
      gender: gen.rows.map(r=>({gender:r.gender,dist:+r.distribution})),
      territories: ter.rows.map(r=>({territory:r.territory,dist:+r.distribution})),
    });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── REPORTS ───────────────────────────────────────────
app.get('/api/clients/:id/reports', auth, async (req, res) => {
  try {
    const { rows } = await pool.query('SELECT month_key,ai_result,updated_at FROM reports WHERE client_id=$1 ORDER BY month_key', [req.params.id]);
    res.json({ reports: rows });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.post('/api/clients/:id/reports', auth, async (req, res) => {
  const { month_key, ai_result } = req.body;
  if (!month_key) return res.status(400).json({ error: 'month_key requis.' });
  try {
    await pool.query(`INSERT INTO reports (client_id,month_key,ai_result,updated_at) VALUES ($1,$2,$3,NOW()) ON CONFLICT (client_id,month_key) DO UPDATE SET ai_result=$3,updated_at=NOW()`,
      [req.params.id, month_key, JSON.stringify(ai_result)]);
    res.json({ ok: true });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ═══════════════════════════════════════════════════════
// BUSINESS MODULE API
// ═══════════════════════════════════════════════════════

// ── TEAM MEMBERS ──────────────────────────────────────
app.get('/api/team', auth, async (req, res) => {
  try {
    const { rows } = await pool.query('SELECT * FROM team_members WHERE active=true ORDER BY name ASC');
    res.json({ team: rows });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.post('/api/team', auth, async (req, res) => {
  const { name, role, hourly_rate, color } = req.body;
  if (!name?.trim()) return res.status(400).json({ error: 'Nom requis.' });
  try {
    const { rows } = await pool.query(
      'INSERT INTO team_members (name,role,hourly_rate,color) VALUES ($1,$2,$3,$4) RETURNING *',
      [name.trim(), role||'', hourly_rate||0, color||'#618F9B']
    );
    res.json({ member: rows[0] });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.put('/api/team/:id', auth, async (req, res) => {
  const { name, role, hourly_rate, color } = req.body;
  try {
    const { rows } = await pool.query(
      'UPDATE team_members SET name=$1,role=$2,hourly_rate=$3,color=$4 WHERE id=$5 RETURNING *',
      [name, role, hourly_rate, color, req.params.id]
    );
    res.json({ member: rows[0] });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.delete('/api/team/:id', auth, async (req, res) => {
  try {
    await pool.query('UPDATE team_members SET active=false WHERE id=$1', [req.params.id]);
    res.json({ ok: true });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── CLIENT CONTRACTS ──────────────────────────────────
app.get('/api/contracts', auth, async (req, res) => {
  try {
    const { rows } = await pool.query(`
      SELECT cc.*, c.name as client_name,
        COALESCE((
          SELECT SUM(te.hours * tm.hourly_rate)
          FROM time_entries te
          JOIN team_members tm ON tm.id = te.team_member_id
          WHERE te.client_id = cc.client_id
          AND DATE_TRUNC('month', te.date) = DATE_TRUNC('month', CURRENT_DATE)
        ), 0) as cost_this_month,
        COALESCE((
          SELECT SUM(te.hours)
          FROM time_entries te
          WHERE te.client_id = cc.client_id
          AND DATE_TRUNC('month', te.date) = DATE_TRUNC('month', CURRENT_DATE)
        ), 0) as hours_this_month,
        COALESCE((
          SELECT COUNT(*) FROM content_items ci
          WHERE ci.client_id = cc.client_id
          AND DATE_TRUNC('month', ci.created_at) = DATE_TRUNC('month', CURRENT_DATE)
        ), 0) as videos_this_month
      FROM client_contracts cc
      JOIN clients c ON c.id = cc.client_id
      WHERE cc.status = 'active'
      ORDER BY cc.mrr DESC`);
    res.json({ contracts: rows });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.post('/api/contracts', auth, async (req, res) => {
  const { client_id, package: pkg, mrr, hours_sold_per_month, contract_start, contact_name, contact_phone, contact_email, notes } = req.body;
  if (!client_id) return res.status(400).json({ error: 'client_id requis.' });
  try {
    const { rows } = await pool.query(`
      INSERT INTO client_contracts (client_id,package,mrr,hours_sold_per_month,contract_start,contact_name,contact_phone,contact_email,notes,updated_at)
      VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,NOW())
      ON CONFLICT DO NOTHING RETURNING *`,
      [client_id, pkg, mrr||0, hours_sold_per_month||0, contract_start||null, contact_name||'', contact_phone||'', contact_email||'', notes||'']
    );
    res.json({ contract: rows[0] });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.put('/api/contracts/:id', auth, async (req, res) => {
  const { package: pkg, mrr, hours_sold_per_month, contract_start, contract_end, status, contact_name, contact_phone, contact_email, notes } = req.body;
  try {
    const { rows } = await pool.query(`
      UPDATE client_contracts SET package=$1,mrr=$2,hours_sold_per_month=$3,contract_start=$4,contract_end=$5,status=$6,contact_name=$7,contact_phone=$8,contact_email=$9,notes=$10,updated_at=NOW()
      WHERE id=$11 RETURNING *`,
      [pkg, mrr, hours_sold_per_month, contract_start||null, contract_end||null, status, contact_name, contact_phone, contact_email, notes, req.params.id]
    );
    res.json({ contract: rows[0] });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── CONTENT ITEMS ─────────────────────────────────────
app.get('/api/content', auth, async (req, res) => {
  const { client_id, status, month } = req.query;
  try {
    let q = `SELECT ci.*, c.name as client_name, tm.name as assignee_name, tm.color as assignee_color,
      COALESCE((SELECT SUM(hours) FROM time_entries WHERE content_item_id=ci.id),0) as total_hours
      FROM content_items ci
      JOIN clients c ON c.id = ci.client_id
      LEFT JOIN team_members tm ON tm.id = ci.assigned_to
      WHERE 1=1`;
    const params = [];
    if (client_id) { params.push(client_id); q += ` AND ci.client_id=$${params.length}`; }
    if (status) { params.push(status); q += ` AND ci.status=$${params.length}`; }
    if (month) { params.push(month+'-01'); q += ` AND DATE_TRUNC('month',ci.post_date)=DATE_TRUNC('month',$${params.length}::date)`; }
    q += ' ORDER BY ci.post_date ASC NULLS LAST, ci.created_at DESC';
    const { rows } = await pool.query(q, params);
    res.json({ items: rows });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.post('/api/content', auth, async (req, res) => {
  const { client_id, title, status, hook_type, objective, format, cta_type, shoot_date, post_date, assigned_to, notes } = req.body;
  if (!client_id || !title?.trim()) return res.status(400).json({ error: 'client_id et title requis.' });
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    // Create content item
    const { rows } = await client.query(`
      INSERT INTO content_items (client_id,title,status,hook_type,objective,format,cta_type,shoot_date,post_date,assigned_to,notes)
      VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11) RETURNING *`,
      [client_id, title.trim(), status||'ideas', hook_type||null, objective||null, format||null, cta_type||null, shoot_date||null, post_date||null, assigned_to||null, notes||'']
    );
    const item = rows[0];
    // Auto-create tasks from task_defaults
    const { rows: defaults } = await client.query('SELECT * FROM task_defaults ORDER BY sort_order');
    for (const def of defaults) {
      await client.query(`
        INSERT INTO content_tasks (content_item_id, client_id, stage, title, assigned_to, default_hours, status)
        VALUES ($1, $2, $3, $4, $5, $6, 'todo')`,
        [item.id, client_id, def.stage, def.label, assigned_to||null, def.default_hours]
      );
    }
    await client.query('COMMIT');
    res.json({ item });
  } catch (err) {
    await client.query('ROLLBACK');
    res.status(500).json({ error: err.message });
  } finally { client.release(); }
});

app.put('/api/content/:id', auth, async (req, res) => {
  const { title, status, hook_type, objective, format, cta_type, shoot_date, post_date, assigned_to, tiktok_views, tiktok_likes, tiktok_shares, performance_score, notes } = req.body;
  try {
    const { rows } = await pool.query(`
      UPDATE content_items SET title=$1,status=$2,hook_type=$3,objective=$4,format=$5,cta_type=$6,
      shoot_date=$7,post_date=$8,assigned_to=$9,tiktok_views=$10,tiktok_likes=$11,tiktok_shares=$12,
      performance_score=$13,notes=$14,updated_at=NOW() WHERE id=$15 RETURNING *`,
      [title, status, hook_type, objective, format, cta_type, shoot_date||null, post_date||null, assigned_to||null, tiktok_views||null, tiktok_likes||null, tiktok_shares||null, performance_score||null, notes, req.params.id]
    );
    res.json({ item: rows[0] });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.delete('/api/content/:id', auth, async (req, res) => {
  try {
    await pool.query('DELETE FROM content_items WHERE id=$1', [req.params.id]);
    res.json({ ok: true });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── TIME ENTRIES ──────────────────────────────────────
app.get('/api/time', auth, async (req, res) => {
  const { client_id, member_id, month } = req.query;
  try {
    let q = `SELECT te.*, tm.name as member_name, tm.hourly_rate, tm.color,
      c.name as client_name, ci.title as content_title,
      te.hours * tm.hourly_rate as cost
      FROM time_entries te
      JOIN team_members tm ON tm.id = te.team_member_id
      JOIN clients c ON c.id = te.client_id
      LEFT JOIN content_items ci ON ci.id = te.content_item_id
      WHERE 1=1`;
    const params = [];
    if (client_id) { params.push(client_id); q += ` AND te.client_id=$${params.length}`; }
    if (member_id) { params.push(member_id); q += ` AND te.team_member_id=$${params.length}`; }
    if (month) { params.push(month+'-01'); q += ` AND DATE_TRUNC('month',te.date)=DATE_TRUNC('month',$${params.length}::date)`; }
    q += ' ORDER BY te.date DESC, te.created_at DESC';
    const { rows } = await pool.query(q, params);
    res.json({ entries: rows });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.post('/api/time', auth, async (req, res) => {
  const { team_member_id, client_id, content_item_id, task_type, hours, date, notes } = req.body;
  if (!team_member_id || !client_id || !hours || !task_type) return res.status(400).json({ error: 'Champs requis manquants.' });
  try {
    const { rows } = await pool.query(`
      INSERT INTO time_entries (team_member_id,client_id,content_item_id,task_type,hours,date,notes)
      VALUES ($1,$2,$3,$4,$5,$6,$7) RETURNING *`,
      [team_member_id, client_id, content_item_id||null, task_type, hours, date||new Date().toISOString().split('T')[0], notes||'']
    );
    res.json({ entry: rows[0] });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.delete('/api/time/:id', auth, async (req, res) => {
  try {
    await pool.query('DELETE FROM time_entries WHERE id=$1', [req.params.id]);
    res.json({ ok: true });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── LEADS ─────────────────────────────────────────────
app.get('/api/leads', auth, async (req, res) => {
  try {
    const { rows } = await pool.query(`
      SELECT l.*, tm.name as owner_name FROM leads l
      LEFT JOIN team_members tm ON tm.id = l.owner_id
      ORDER BY l.updated_at DESC`);
    res.json({ leads: rows });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.post('/api/leads', auth, async (req, res) => {
  const { company, contact_name, phone, email, source, status, estimated_mrr, service_type, probability, close_date, owner_id, next_action_date, notes } = req.body;
  if (!company?.trim()) return res.status(400).json({ error: 'Entreprise requise.' });
  try {
    const { rows } = await pool.query(`
      INSERT INTO leads (company,contact_name,phone,email,source,status,estimated_mrr,service_type,probability,close_date,owner_id,next_action_date,notes)
      VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13) RETURNING *`,
      [company.trim(), contact_name||'', phone||'', email||'', source||'referral', status||'new', estimated_mrr||null, service_type||'', probability||20, close_date||null, owner_id||null, next_action_date||null, notes||'']
    );
    res.json({ lead: rows[0] });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.put('/api/leads/:id', auth, async (req, res) => {
  const { company, contact_name, phone, email, source, status, estimated_mrr, service_type, probability, close_date, owner_id, next_action_date, notes } = req.body;
  try {
    const { rows } = await pool.query(`
      UPDATE leads SET company=$1,contact_name=$2,phone=$3,email=$4,source=$5,status=$6,estimated_mrr=$7,
      service_type=$8,probability=$9,close_date=$10,owner_id=$11,next_action_date=$12,notes=$13,updated_at=NOW()
      WHERE id=$14 RETURNING *`,
      [company, contact_name, phone, email, source, status, estimated_mrr, service_type, probability, close_date||null, owner_id||null, next_action_date||null, notes, req.params.id]
    );
    res.json({ lead: rows[0] });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.delete('/api/leads/:id', auth, async (req, res) => {
  try {
    await pool.query('DELETE FROM leads WHERE id=$1', [req.params.id]);
    res.json({ ok: true });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── RENTABILITÉ DASHBOARD ─────────────────────────────
app.get('/api/rentabilite', auth, async (req, res) => {
  const { month } = req.query;
  const monthFilter = month || new Date().toISOString().slice(0,7);
  try {
    // Per client profitability
    const { rows: clients } = await pool.query(`
      SELECT
        c.id, c.name,
        COALESCE(cc.mrr, 0) as mrr,
        COALESCE(cc.hours_sold_per_month, 0) as hours_sold,
        COALESCE(cc.package, '—') as package,
        COALESCE(SUM(te.hours), 0) as hours_spent,
        COALESCE(SUM(te.hours * tm.hourly_rate), 0) as total_cost,
        COALESCE(cc.mrr, 0) - COALESCE(SUM(te.hours * tm.hourly_rate), 0) as margin,
        COUNT(DISTINCT ci.id) as videos_count
      FROM clients c
      LEFT JOIN client_contracts cc ON cc.client_id = c.id AND cc.status = 'active'
      LEFT JOIN time_entries te ON te.client_id = c.id
        AND DATE_TRUNC('month', te.date) = DATE_TRUNC('month', ($1 || '-01')::date)
      LEFT JOIN team_members tm ON tm.id = te.team_member_id
      LEFT JOIN content_items ci ON ci.client_id = c.id
        AND DATE_TRUNC('month', COALESCE(ci.post_date, ci.created_at)) = DATE_TRUNC('month', ($1 || '-01')::date)
      WHERE cc.status = 'active' OR cc.status IS NULL
      GROUP BY c.id, c.name, cc.mrr, cc.hours_sold_per_month, cc.package
      ORDER BY margin ASC`,
      [monthFilter]
    );

    // Global summary
    const totalMRR = clients.reduce((s, c) => s + +c.mrr, 0);
    const totalCost = clients.reduce((s, c) => s + +c.total_cost, 0);
    const totalHoursSpent = clients.reduce((s, c) => s + +c.hours_spent, 0);
    const totalHoursSold = clients.reduce((s, c) => s + +c.hours_sold, 0);
    const totalMargin = totalMRR - totalCost;
    const marginPct = totalMRR > 0 ? ((totalMargin / totalMRR) * 100).toFixed(1) : 0;

    // Per member summary
    const { rows: byMember } = await pool.query(`
      SELECT tm.name, tm.color, tm.hourly_rate,
        COALESCE(SUM(te.hours), 0) as total_hours,
        COALESCE(SUM(te.hours * tm.hourly_rate), 0) as total_cost
      FROM team_members tm
      LEFT JOIN time_entries te ON te.team_member_id = tm.id
        AND DATE_TRUNC('month', te.date) = DATE_TRUNC('month', ($1 || '-01')::date)
      WHERE tm.active = true
      GROUP BY tm.id, tm.name, tm.color, tm.hourly_rate
      ORDER BY total_hours DESC`,
      [monthFilter]
    );

    // Alerts: clients over budget
    const alerts = clients
      .filter(c => +c.hours_sold > 0 && +c.hours_spent > +c.hours_sold)
      .map(c => ({ client: c.name, hours_spent: +c.hours_spent, hours_sold: +c.hours_sold, over: +(c.hours_spent - c.hours_sold).toFixed(1) }));

    res.json({
      month: monthFilter,
      summary: { totalMRR, totalCost, totalMargin, marginPct, totalHoursSpent, totalHoursSold },
      clients,
      byMember,
      alerts
    });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── AI PROXY ──────────────────────────────────────────
app.post('/api/analyze', auth, (req, res) => {
  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) return res.status(500).json({ error: 'OPENAI_API_KEY not configured.' });
  const { data } = req.body;
  if (!data) return res.status(400).json({ error: 'Données manquantes.' });

  const { analyseMonth, monthViews, monthLikes, monthShares, monthVideos, totalViewsFull, followers, followerGrowthFull, avgEng, avgShareRate, avgLikeRate, startDate, beforeAfter, monthVsPrev, top5 } = data;

  const systemPrompt = `Tu es l'IA analytique senior de Mazine.mu, une agence de création de contenu TikTok basée à Maurice. Réponds uniquement en JSON valide, sans markdown, sans backticks.`;

  const userPrompt = `Produis le rapport TikTok de ${analyseMonth||'la période'}.
Vues: ${monthViews} | Likes: ${monthLikes} | Partages: ${monthShares} | Vidéos: ${monthVideos}
Engagement: ${avgEng}% | Viralité: ${avgShareRate}% | Abonnés: ${followers}
${beforeAfter ? `Impact Mazine: ${beforeAfter}` : ''}
TOP 5: ${top5.map((v,i) => `${i+1}. "${v.title}" — ${v.views} vues, ${v.engRate}% eng`).join(' | ')}

JSON:
{"synthese":"3-4 phrases chiffrées.","diagnostic":{"points_forts":["x","x","x"],"points_amelioration":["x","x"]},"analyse_viralite":"2 phrases.","videos":[{"rank":1,"format":"catégorie","pourquoi":"raison"}],"brief_prochain_contenu":{"angle_prioritaire":"x","format_recommande":"x","accroche_type":"x","a_eviter":"x"},"recommandations":["x","x","x","x"]}`;

  fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'Authorization': 'Bearer ' + apiKey },
    body: JSON.stringify({ model: 'gpt-4o', max_tokens: 1500, response_format: { type: 'json_object' }, messages: [{ role: 'system', content: systemPrompt }, { role: 'user', content: userPrompt }] })
  })
  .then(r => r.json())
  .then(d => {
    if (d.error) return res.status(500).json({ error: d.error.message });
    res.json({ result: JSON.parse(d.choices[0].message.content.replace(/```json|```/g,'').trim()) });
  })
  .catch(err => res.status(500).json({ error: err.message }));
});

// ── TASK DEFAULTS ────────────────────────────────────
app.get('/api/task-defaults', auth, async (req, res) => {
  try {
    const { rows } = await pool.query('SELECT * FROM task_defaults ORDER BY sort_order');
    res.json({ defaults: rows });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.put('/api/task-defaults/:stage', auth, async (req, res) => {
  const { default_hours, label } = req.body;
  try {
    const { rows } = await pool.query(
      'UPDATE task_defaults SET default_hours=$1, label=$2 WHERE stage=$3 RETURNING *',
      [default_hours, label, req.params.stage]
    );
    res.json({ default: rows[0] });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── CONTENT TASKS ─────────────────────────────────────
app.get('/api/content/:id/tasks', auth, async (req, res) => {
  try {
    const { rows } = await pool.query(`
      SELECT ct.*, tm.name as assignee_name, tm.color as assignee_color,
        td.emoji, td.sort_order
      FROM content_tasks ct
      LEFT JOIN team_members tm ON tm.id = ct.assigned_to
      LEFT JOIN task_defaults td ON td.stage = ct.stage
      WHERE ct.content_item_id = $1
      ORDER BY td.sort_order`, [req.params.id]);
    res.json({ tasks: rows });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.put('/api/tasks/:id', auth, async (req, res) => {
  const { status, assigned_to, default_hours, due_date, notes } = req.body;
  try {
    const doneAt = status === 'done' ? 'NOW()' : 'NULL';
    const { rows } = await pool.query(`
      UPDATE content_tasks SET status=$1, assigned_to=$2, default_hours=$3, due_date=$4, notes=$5,
      done_at=${doneAt} WHERE id=$6 RETURNING *`,
      [status, assigned_to||null, default_hours, due_date||null, notes||'', req.params.id]
    );
    res.json({ task: rows[0] });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── CALENDAR ──────────────────────────────────────────
// Returns all events (content shoot/post dates + tasks) for a given month
app.get('/api/calendar', auth, async (req, res) => {
  const { month } = req.query; // YYYY-MM
  const m = month || new Date().toISOString().slice(0,7);
  try {
    // Content items with shoot and post dates this month
    const { rows: items } = await pool.query(`
      SELECT ci.id, ci.title, ci.status, ci.shoot_date, ci.post_date,
        ci.client_id, c.name as client_name,
        tm.name as assignee_name, tm.color as assignee_color
      FROM content_items ci
      JOIN clients c ON c.id = ci.client_id
      LEFT JOIN team_members tm ON tm.id = ci.assigned_to
      WHERE (
        DATE_TRUNC('month', ci.shoot_date) = DATE_TRUNC('month', ($1||'-01')::date)
        OR DATE_TRUNC('month', ci.post_date) = DATE_TRUNC('month', ($1||'-01')::date)
      )
      ORDER BY COALESCE(ci.shoot_date, ci.post_date) ASC`, [m]);

    // Tasks with due dates this month
    const { rows: tasks } = await pool.query(`
      SELECT ct.id, ct.stage, ct.title as stage_label, ct.status, ct.due_date,
        ct.default_hours, ct.content_item_id,
        ci.title as video_title, ci.client_id,
        c.name as client_name,
        tm.name as assignee_name, tm.color as assignee_color,
        td.emoji
      FROM content_tasks ct
      JOIN content_items ci ON ci.id = ct.content_item_id
      JOIN clients c ON c.id = ci.client_id
      LEFT JOIN team_members tm ON tm.id = ct.assigned_to
      LEFT JOIN task_defaults td ON td.stage = ct.stage
      WHERE DATE_TRUNC('month', ct.due_date) = DATE_TRUNC('month', ($1||'-01')::date)
      ORDER BY ct.due_date ASC`, [m]);

    res.json({ items, tasks });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── FALLBACK ──────────────────────────────────────────
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(PORT, () => console.log(`Mazine running on port ${PORT}`));