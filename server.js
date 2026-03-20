const express = require('express');
const path = require('path');
const crypto = require('crypto');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json({ limit: '2mb' }));
app.use(express.static(path.join(__dirname, 'public')));

// Simple in-memory session store (token → expiry)
const sessions = new Map();
const SESSION_TTL = 8 * 60 * 60 * 1000; // 8 hours

function createToken() {
  return crypto.randomBytes(32).toString('hex');
}

function isAuthenticated(req) {
  const auth = req.headers['authorization'] || '';
  const token = auth.replace('Bearer ', '').trim();
  if (!token) return false;
  const expiry = sessions.get(token);
  if (!expiry || Date.now() > expiry) { sessions.delete(token); return false; }
  return true;
}

// ── AUTH ──────────────────────────────────────────────
app.post('/api/login', (req, res) => {
  const { password } = req.body;
  const expected = process.env.APP_PASSWORD;
  if (!expected) return res.status(500).json({ error: 'APP_PASSWORD not configured on server.' });
  if (password !== expected) return res.status(401).json({ error: 'Mot de passe incorrect.' });
  const token = createToken();
  sessions.set(token, Date.now() + SESSION_TTL);
  res.json({ token });
});

app.post('/api/logout', (req, res) => {
  const auth = req.headers['authorization'] || '';
  sessions.delete(auth.replace('Bearer ', '').trim());
  res.json({ ok: true });
});

// ── OPENAI PROXY ──────────────────────────────────────
app.post('/api/analyze', (req, res) => {
  if (!isAuthenticated(req)) return res.status(401).json({ error: 'Non authentifié.' });

  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) return res.status(500).json({ error: 'OPENAI_API_KEY not configured on server.' });

  const { data } = req.body;
  if (!data) return res.status(400).json({ error: 'Données manquantes.' });

  const {
    analyseMonth, monthViews, monthLikes, monthShares, monthVideos,
    totalViewsFull, followers, followerGrowthFull,
    avgEng, avgShareRate, avgLikeRate,
    startDate, beforeAfter, monthVsPrev,
    top5
  } = data;

  const systemPrompt = `Tu es l'IA analytique senior de Mazine.mu, une agence de création de contenu TikTok basée à Maurice.
Tu analyses les performances TikTok de nos clients avec un regard stratégique et éditorial.
Ton rôle est de transformer la data brute en insights actionnables qui démontrent la valeur du partenariat Mazine.
Tu connais les spécificités du marché mauricien : audience bilingue créole/français, forte affinité mobile, pics d'activité en soirée, sensibilité aux promotions locales et événements (fêtes, ramadan, vacances scolaires).
Réponds uniquement en JSON valide, sans markdown, sans backticks.`;

  const userPrompt = `Produis le rapport mensuel TikTok de ${analyseMonth || 'la période sélectionnée'}.

━━━ CONTEXTE GLOBAL (365 jours) ━━━
- Total vues sur l'année : ${totalViewsFull || 'N/A'}
- Abonnés actuels : ${followers || 'N/A'}
${followerGrowthFull ? `- Croissance totale abonnés : +${followerGrowthFull}` : ''}
${beforeAfter ? `- Impact partenariat Mazine (depuis ${startDate}) : ${beforeAfter}` : ''}

━━━ MÉTRIQUES DU MOIS : ${analyseMonth || 'période'} ━━━
- Vues : ${monthViews}
- Likes : ${monthLikes}
- Partages : ${monthShares}
- Vidéos publiées ce mois : ${monthVideos}
- Engagement moyen (top vidéos) : ${avgEng}%
- Taux de viralité moyen (partages/vues) : ${avgShareRate}%
- Taux d'affinité moyen (likes/vues) : ${avgLikeRate}%
${monthVsPrev ? `- Tendance : ${monthVsPrev}` : ''}

━━━ TOP 5 VIDÉOS DU MOIS ━━━
${top5.map((v, i) => `${i+1}. "${v.title}"
   Vues : ${v.views} | Likes : ${v.likes} | Commentaires : ${v.comments} | Partages : ${v.shares}
   Engagement : ${v.engRate}% | Viralité : ${v.shareRate}% | Publié : ${v.postTime || 'N/A'}`).join('\n\n')}

Produis le rapport JSON suivant. Chaque champ doit être précis, chiffré quand possible, et directement utile pour une réunion client :
{
  "synthese": "3-4 phrases. Résume les faits saillants du mois avec des chiffres concrets. Compare vs mois précédent si disponible. Mentionne l'impact Mazine si pertinent. Ton direct et professionnel.",

  "diagnostic": {
    "points_forts": [
      "Point fort 1 — appuyé par un chiffre précis du mois",
      "Point fort 2",
      "Point fort 3"
    ],
    "points_amelioration": [
      "Levier de croissance 1 — concret et actionnable",
      "Levier de croissance 2"
    ]
  },

  "analyse_viralite": "2 phrases max. Interprète le ratio partages/vues de ce mois. Un ratio élevé = contenu que les gens veulent montrer. Qu'est-ce que ça révèle sur ce qui résonne avec l'audience mauricienne ce mois-ci ?",

  "videos": [
    {
      "rank": 1,
      "format": "Catégorie précise : démonstration produit / UGC reply / promotion / storytelling / behind-the-scenes / tutoriel / contenu saisonnier",
      "pourquoi": "1 phrase sur le facteur clé de succès — qu'est-ce qui a déclenché la performance ?"
    }
  ],

  "brief_prochain_contenu": {
    "angle_prioritaire": "Le thème dominant à poursuivre le mois prochain, basé sur ce qui a performé",
    "format_recommande": "Format exact : durée cible, structure narrative, style visuel",
    "accroche_type": "Type d'accroche à privilégier (question, chiffre choc, before/after, défi, réponse commentaire…)",
    "a_eviter": "Ce qui n'a pas performé ce mois ou ce qui risque de saturer — avec justification"
  },

  "recommandations": [
    "Recommandation 1 — ultra concrète, avec données du mois si possible",
    "Recommandation 2",
    "Recommandation 3",
    "Recommandation 4"
  ]
}`;

  fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'Authorization': 'Bearer ' + apiKey },
    body: JSON.stringify({
      model: 'gpt-4o',
      max_tokens: 1500,
      response_format: { type: 'json_object' },
      messages: [
        { role: 'system', content: systemPrompt },
        { role: 'user', content: userPrompt }
      ]
    })
  })
  .then(r => r.json())
  .then(openaiData => {
    if (openaiData.error) return res.status(500).json({ error: openaiData.error.message });
    const txt = openaiData.choices[0].message.content.replace(/```json|```/g, '').trim();
    res.json({ result: JSON.parse(txt) });
  })
  .catch(err => res.status(500).json({ error: err.message }));
});

// ── FALLBACK ──────────────────────────────────────────
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(PORT, () => {
  console.log(`Mazine Analytics running on port ${PORT}`);
});