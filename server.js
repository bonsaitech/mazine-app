const express = require('express');
const path = require('path');
const crypto = require('crypto');
const { Pool } = require('pg');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json({ limit: '20mb' })); // larger limit for bulk data
app.use(express.static(path.join(__dirname, 'public')));

// ── DATABASE ──────────────────────────────────────────
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

async function initDB() {
  await pool.query(`
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

    -- Daily time-series data
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

    -- Video content (upsert on title)
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

    -- Static distributions (replace on upload)
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

// ── CLIENTS ───────────────────────────────────────────
app.get('/api/clients', async (req, res) => {
  if (!isAuthenticated(req)) return res.status(401).json({ error: 'Non authentifié.' });
  try {
    const { rows } = await pool.query(
      `SELECT c.id, c.name, c.mazine_start_date,
        (SELECT MAX(updated_at) FROM tiktok_overview WHERE client_id=c.id) as last_upload
       FROM clients c ORDER BY c.name ASC`
    );
    res.json({ clients: rows });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.post('/api/clients', async (req, res) => {
  if (!isAuthenticated(req)) return res.status(401).json({ error: 'Non authentifié.' });
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

app.put('/api/clients/:id', async (req, res) => {
  if (!isAuthenticated(req)) return res.status(401).json({ error: 'Non authentifié.' });
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

app.delete('/api/clients/:id', async (req, res) => {
  if (!isAuthenticated(req)) return res.status(401).json({ error: 'Non authentifié.' });
  try {
    await pool.query('DELETE FROM clients WHERE id=$1', [req.params.id]);
    res.json({ ok: true });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── TIKTOK DATA — SAVE (upsert) ───────────────────────
app.post('/api/clients/:id/data', async (req, res) => {
  if (!isAuthenticated(req)) return res.status(401).json({ error: 'Non authentifié.' });
  const clientId = req.params.id;
  const { overview, followers, viewers, activity, content, gender, territories } = req.body;
  const client = await pool.connect();

  try {
    await client.query('BEGIN');

    // ── Overview ──
    if (overview?.length) {
      for (const row of overview) {
        if (!row.date) continue;
        await client.query(`
          INSERT INTO tiktok_overview (client_id, date, views, likes, comments, shares, updated_at)
          VALUES ($1, $2, $3, $4, $5, $6, NOW())
          ON CONFLICT (client_id, date) DO UPDATE
          SET views=$3, likes=$4, comments=$5, shares=$6, updated_at=NOW()
        `, [clientId, row.date, row.views||0, row.likes||0, row.comments||0, row.shares||0]);
      }
    }

    // ── Followers ──
    if (followers?.length) {
      for (const row of followers) {
        if (!row.date) continue;
        await client.query(`
          INSERT INTO tiktok_followers (client_id, date, followers, diff, updated_at)
          VALUES ($1, $2, $3, $4, NOW())
          ON CONFLICT (client_id, date) DO UPDATE
          SET followers=$3, diff=$4, updated_at=NOW()
        `, [clientId, row.date, row.followers||0, row.diff||0]);
      }
    }

    // ── Viewers ──
    if (viewers?.length) {
      for (const row of viewers) {
        if (!row.date) continue;
        await client.query(`
          INSERT INTO tiktok_viewers (client_id, date, new_viewers, returning_viewers, updated_at)
          VALUES ($1, $2, $3, $4, NOW())
          ON CONFLICT (client_id, date) DO UPDATE
          SET new_viewers=$3, returning_viewers=$4, updated_at=NOW()
        `, [clientId, row.date, row.newV||0, row.returning||0]);
      }
    }

    // ── Activity ──
    if (activity?.length) {
      for (const row of activity) {
        if (!row.date) continue;
        await client.query(`
          INSERT INTO tiktok_activity (client_id, date, hour, active_followers, updated_at)
          VALUES ($1, $2, $3, $4, NOW())
          ON CONFLICT (client_id, date, hour) DO UPDATE
          SET active_followers=$4, updated_at=NOW()
        `, [clientId, row.date, row.hour||0, row.active||0]);
      }
    }

    // ── Content ──
    if (content?.length) {
      for (const row of content) {
        if (!row.title) continue;
        await client.query(`
          INSERT INTO tiktok_content (client_id, title, views, likes, comments, shares, post_time, updated_at)
          VALUES ($1, $2, $3, $4, $5, $6, $7, NOW())
          ON CONFLICT (client_id, title) DO UPDATE
          SET views=$3, likes=$4, comments=$5, shares=$6, post_time=$7, updated_at=NOW()
        `, [clientId, row.title, row.views||0, row.likes||0, row.comments||0, row.shares||0, row.postTime||null]);
      }
    }

    // ── Gender (replace all for client) ──
    if (gender?.length) {
      await client.query('DELETE FROM tiktok_gender WHERE client_id=$1', [clientId]);
      for (const row of gender) {
        if (!row.gender) continue;
        await client.query(`
          INSERT INTO tiktok_gender (client_id, gender, distribution, updated_at)
          VALUES ($1, $2, $3, NOW())
          ON CONFLICT (client_id, gender) DO UPDATE SET distribution=$3, updated_at=NOW()
        `, [clientId, row.gender, row.dist||0]);
      }
    }

    // ── Territories (replace all for client) ──
    if (territories?.length) {
      await client.query('DELETE FROM tiktok_territories WHERE client_id=$1', [clientId]);
      for (const row of territories) {
        if (!row.territory) continue;
        await client.query(`
          INSERT INTO tiktok_territories (client_id, territory, distribution, updated_at)
          VALUES ($1, $2, $3, NOW())
          ON CONFLICT (client_id, territory) DO UPDATE SET distribution=$3, updated_at=NOW()
        `, [clientId, row.territory, row.dist||0]);
      }
    }

    await client.query('COMMIT');
    res.json({ ok: true, saved: {
      overview: overview?.length||0,
      followers: followers?.length||0,
      viewers: viewers?.length||0,
      activity: activity?.length||0,
      content: content?.length||0,
      gender: gender?.length||0,
      territories: territories?.length||0,
    }});
  } catch (err) {
    await client.query('ROLLBACK');
    console.error('Data save error:', err);
    res.status(500).json({ error: err.message });
  } finally {
    client.release();
  }
});

// ── TIKTOK DATA — LOAD ────────────────────────────────
app.get('/api/clients/:id/data', async (req, res) => {
  if (!isAuthenticated(req)) return res.status(401).json({ error: 'Non authentifié.' });
  const clientId = req.params.id;
  try {
    const [ov, fol, view, act, cont, gen, ter] = await Promise.all([
      pool.query('SELECT date, views, likes, comments, shares FROM tiktok_overview WHERE client_id=$1 ORDER BY date ASC', [clientId]),
      pool.query('SELECT date, followers, diff FROM tiktok_followers WHERE client_id=$1 ORDER BY date ASC', [clientId]),
      pool.query('SELECT date, new_viewers, returning_viewers FROM tiktok_viewers WHERE client_id=$1 ORDER BY date ASC', [clientId]),
      pool.query('SELECT date, hour, active_followers FROM tiktok_activity WHERE client_id=$1 ORDER BY date ASC, hour ASC', [clientId]),
      pool.query('SELECT title, views, likes, comments, shares, post_time FROM tiktok_content WHERE client_id=$1 ORDER BY views DESC', [clientId]),
      pool.query('SELECT gender, distribution FROM tiktok_gender WHERE client_id=$1', [clientId]),
      pool.query('SELECT territory, distribution FROM tiktok_territories WHERE client_id=$1 ORDER BY distribution DESC', [clientId]),
    ]);

    // Count total rows to tell client if data exists
    const total = ov.rowCount + fol.rowCount + cont.rowCount;

    res.json({
      hasData: total > 0,
      overview:     ov.rows.map(r => ({ dateRaw: r.date, date: r.date, views: +r.views, likes: +r.likes, comments: +r.comments, shares: +r.shares })),
      followers:    fol.rows.map(r => ({ dateRaw: r.date, date: r.date, followers: +r.followers, diff: +r.diff })),
      viewers:      view.rows.map(r => ({ dateRaw: r.date, date: r.date, newV: +r.new_viewers, returning: +r.returning_viewers })),
      activity:     act.rows.map(r => ({ dateRaw: r.date, date: r.date, hour: +r.hour, active: +r.active_followers })),
      content:      cont.rows.map(r => ({ title: r.title, views: +r.views, likes: +r.likes, comments: +r.comments, shares: +r.shares, postTime: r.post_time })),
      gender:       gen.rows.map(r => ({ gender: r.gender, dist: +r.distribution })),
      territories:  ter.rows.map(r => ({ territory: r.territory, dist: +r.distribution })),
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ── REPORTS ───────────────────────────────────────────
app.get('/api/clients/:id/reports', async (req, res) => {
  if (!isAuthenticated(req)) return res.status(401).json({ error: 'Non authentifié.' });
  try {
    const { rows } = await pool.query(
      'SELECT month_key, ai_result, updated_at FROM reports WHERE client_id=$1 ORDER BY month_key',
      [req.params.id]
    );
    res.json({ reports: rows });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.post('/api/clients/:id/reports', async (req, res) => {
  if (!isAuthenticated(req)) return res.status(401).json({ error: 'Non authentifié.' });
  const { month_key, ai_result } = req.body;
  if (!month_key) return res.status(400).json({ error: 'month_key requis.' });
  try {
    await pool.query(`
      INSERT INTO reports (client_id, month_key, ai_result, updated_at)
      VALUES ($1, $2, $3, NOW())
      ON CONFLICT (client_id, month_key) DO UPDATE SET ai_result=$3, updated_at=NOW()
    `, [req.params.id, month_key, JSON.stringify(ai_result)]);
    res.json({ ok: true });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── AI PROXY ──────────────────────────────────────────
app.post('/api/analyze', (req, res) => {
  if (!isAuthenticated(req)) return res.status(401).json({ error: 'Non authentifié.' });
  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) return res.status(500).json({ error: 'OPENAI_API_KEY not configured.' });
  const { data } = req.body;
  if (!data) return res.status(400).json({ error: 'Données manquantes.' });

  const {
    analyseMonth, monthViews, monthLikes, monthShares, monthVideos,
    totalViewsFull, followers, followerGrowthFull,
    avgEng, avgShareRate, avgLikeRate,
    startDate, beforeAfter, monthVsPrev, top5
  } = data;

  const systemPrompt = `Tu es l'IA analytique senior de Mazine.mu, une agence de création de contenu TikTok basée à Maurice.
Tu analyses les performances TikTok de nos clients avec un regard stratégique et éditorial.
Ton rôle est de transformer la data brute en insights actionnables qui démontrent la valeur du partenariat Mazine.
Tu connais les spécificités du marché mauricien : audience bilingue créole/français, forte affinité mobile, pics d'activité en soirée, sensibilité aux promotions locales et événements (fêtes, ramadan, vacances scolaires).
Réponds uniquement en JSON valide, sans markdown, sans backticks.`;

  const userPrompt = `Produis le rapport TikTok de ${analyseMonth || 'la période sélectionnée'}.

━━━ CONTEXTE GLOBAL ━━━
- Total vues : ${totalViewsFull || 'N/A'}
- Abonnés actuels : ${followers || 'N/A'}
${followerGrowthFull ? `- Croissance abonnés : +${followerGrowthFull}` : ''}
${beforeAfter ? `- Impact partenariat Mazine (depuis ${startDate}) : ${beforeAfter}` : ''}

━━━ MÉTRIQUES : ${analyseMonth || 'période'} ━━━
- Vues : ${monthViews} | Likes : ${monthLikes} | Partages : ${monthShares}
- Vidéos publiées : ${monthVideos}
- Engagement moyen : ${avgEng}% | Viralité : ${avgShareRate}% | Affinité : ${avgLikeRate}%
${monthVsPrev ? `- Tendance : ${monthVsPrev}` : ''}

━━━ TOP 5 VIDÉOS ━━━
${top5.map((v, i) => `${i+1}. "${v.title}" — ${v.views} vues | Eng: ${v.engRate}% | Viral: ${v.shareRate}%`).join('\n')}

Réponds avec ce JSON exact :
{
  "synthese": "3-4 phrases avec chiffres concrets.",
  "diagnostic": {
    "points_forts": ["Point 1 chiffré", "Point 2", "Point 3"],
    "points_amelioration": ["Levier 1 actionnable", "Levier 2"]
  },
  "analyse_viralite": "2 phrases max sur le ratio partages/vues.",
  "videos": [{"rank": 1, "format": "Catégorie précise", "pourquoi": "Facteur clé de succès"}],
  "brief_prochain_contenu": {
    "angle_prioritaire": "Thème dominant",
    "format_recommande": "Format exact",
    "accroche_type": "Type d'accroche",
    "a_eviter": "Ce qui n'a pas performé"
  },
  "recommandations": ["Reco 1", "Reco 2", "Reco 3", "Reco 4"]
}`;

  fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'Authorization': 'Bearer ' + apiKey },
    body: JSON.stringify({
      model: 'gpt-4o', max_tokens: 1500,
      response_format: { type: 'json_object' },
      messages: [{ role: 'system', content: systemPrompt }, { role: 'user', content: userPrompt }]
    })
  })
  .then(r => r.json())
  .then(d => {
    if (d.error) return res.status(500).json({ error: d.error.message });
    res.json({ result: JSON.parse(d.choices[0].message.content.replace(/```json|```/g, '').trim()) });
  })
  .catch(err => res.status(500).json({ error: err.message }));
});

// ── FALLBACK ──────────────────────────────────────────
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(PORT, () => console.log(`Mazine Analytics running on port ${PORT}`));