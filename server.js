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
    totalViews, followers, followerGrowth, avgEng, totalVideos,
    top5, avgShareRate, avgLikeRate, startDate, beforeAfter
  } = data;

  const systemPrompt = `Tu es l'IA analytique senior de Mazine.mu, une agence de création de contenu TikTok basée à Maurice. 
Tu analyses les performances TikTok de nos clients avec un regard stratégique et éditorial. 
Ton rôle est de transformer la data brute en insights actionnables qui démontrent la valeur du partenariat Mazine.
Tu connais les spécificités du marché mauricien : audience bilingue créole/français, forte affinité mobile, pics d'activité en soirée, sensibilité aux promotions locales.
Réponds uniquement en JSON valide, sans markdown, sans backticks.`;

  const userPrompt = `Analyse les performances TikTok du client avec ces données :

MÉTRIQUES GLOBALES
- Total vues : ${totalViews}
- Vidéos publiées : ${totalVideos}
- Abonnés actuels : ${followers || 'N/A'}
${followerGrowth ? `- Croissance abonnés (période) : +${followerGrowth}` : ''}
- Engagement moyen (top vidéos) : ${avgEng}%
- Taux de partage moyen : ${avgShareRate}% (partages/vues — indicateur de viralité)
- Taux de like moyen : ${avgLikeRate}% (likes/vues — indicateur d'affinité)

${beforeAfter ? `IMPACT DEPUIS LE DÉBUT DU PARTENARIAT MAZINE (${startDate})
${beforeAfter}` : ''}

TOP 5 VIDÉOS (classées par score de performance)
${top5.map((v, i) => `
${i+1}. "${v.title}"
   - Vues : ${v.views} | Likes : ${v.likes} | Commentaires : ${v.comments} | Partages : ${v.shares}
   - Engagement : ${v.engRate}% | Ratio partages/vues : ${v.shareRate}%
   - Publié le : ${v.postTime || 'N/A'}`).join('\n')}

Produis une analyse JSON avec cette structure exacte :
{
  "synthese": "3-4 phrases d'analyse stratégique. Identifie les patterns dominants, la signature éditoriale qui performe, et l'impact mesurable du partenariat Mazine si applicable. Ton direct, chiffré, professionnel.",
  
  "diagnostic": {
    "points_forts": ["Point fort 1 appuyé par la data", "Point fort 2", "Point fort 3"],
    "points_amelioration": ["Levier de croissance 1", "Levier de croissance 2"]
  },
  
  "analyse_viralite": "1-2 phrases sur le ratio partages/likes. Un ratio partages élevé = contenu que les gens veulent montrer à leurs proches. Explique ce que ça révèle sur l'audience.",
  
  "videos": [
    {"rank": 1, "format": "Type de contenu (ex: démonstration produit, UGC reply, promo, storytelling, behind-the-scenes)", "pourquoi": "1 phrase précise sur le facteur clé de succès de cette vidéo spécifique"}
  ],
  
  "brief_prochain_contenu": {
    "angle_prioritaire": "Le thème/angle qui devrait dominer les prochaines publications basé sur la data",
    "format_recommande": "Format précis à reproduire (durée, structure, style)",
    "accroche_type": "Type d'accroche qui performe pour ce client (question, chiffre choc, before/after, etc.)",
    "a_eviter": "Ce qui ne performe pas ou risque de saturer l'audience"
  },
  
  "recommandations": [
    "Recommandation 1 — très concrète et actionnable, avec contexte chiffré si possible",
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
